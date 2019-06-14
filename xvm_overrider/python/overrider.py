import json
import logging
import os.path
import sys
from xvm_main.python.config import config_data, get

# Change this to sys.stderr to have messages stand out better in the python.log.
log_tgt = sys.stderr


class Overrider:
    ov_key = "__xvm_overrider__"

    def __init__(self):
        self.should_dump_config = False
        pass

    def load_overrides(self):
        overrides_json = os.path.join(os.path.split(__file__)[0], "..", "overrides.json")
        self.overrides = {}
        with open(overrides_json) as overrides:
            self.overrides = json.load(overrides, encoding="utf8")
        if 'dumpConfig' in self.overrides and self.overrides['dumpConfig']:
            self.should_dump_config = True
            print >>log_tgt, "===> Auto dump of config data is active."

    def dump_config(self):
        if not self.should_dump_config:
            return
        global config_data
        dump_filename = os.path.join(os.getcwd(), "config_data.json")
        with open(dump_filename, "wt") as config_data_file:
            json.dump(config_data, config_data_file, indent=4, ensure_ascii=False)
            print >>log_tgt, "===> Config data dumped to: {}".format(dump_filename)

    def override_values(self, e=None):
        self.load_overrides()
        global config_data
        config_data = self.merge_configs(self.overrides, config_data)
        self.dump_config()

    def merge_lists(self, padding, a, b):
        result = []
        for a_item in a:
            for b_item in b:
                key = ""
                value = ""
                try:
                    key = b_item[Overrider.ov_key]["key"]
                    value = b_item[Overrider.ov_key]["value"]
                except KeyError:
                    print log_tgt, "===> Bad item = {}".format(b_item)
                    continue
                if key in a_item and a_item[key] == value:
                    source = b_item.copy()
                    source.pop(Overrider.ov_key, None)
                    print >>log_tgt, "{}'{}:{}' matched, thus overrode with values {}".format(
                        padding, key, value, source)
                    a_item.update(source)
            result.append(a_item)
        return result

    def merge_configs(self, original, result, path=[]):
        if type(result) != type(original):
            print >>log_tgt, "===> merge_configs: {} expected {}, got {}. Default value loaded".format(
                "/".join(path), type(original).__name__, type(result).__name__
            )
            return original
        for key, value in original.iteritems():
            path.append(key)
            padding = "===> "
            for _ in range(1, len(path)):
                padding = "  {}".format(padding)
            if key not in result or isinstance(value, bool):
                if len(path):
                    prefix = ".".join(path)
                print >>log_tgt, "{}{} overridden with value = {}".format(padding, prefix, value)
                result[key] = value
            elif isinstance(value, dict):
                print >>log_tgt, "{}{} is a dict".format(padding, key)
                result[key] = self.merge_configs(value, result[key], path)
            elif isinstance(value, list):
                if isinstance(value[0], dict):
                    print >>log_tgt, "{}Should merge as the list '{}' contains dictionaries.".format(
                        padding, ".".join(path))
                    result[key] = self.merge_lists(padding, result[key], value)
                else:
                    print >>log_tgt, "{}{} overridden with value = {}".format(padding, ".".join(path), value)
                    result[key] = value
            path.pop()
        return result
