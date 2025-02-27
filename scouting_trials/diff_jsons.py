import json
import argparse

parser = argparse.ArgumentParser()

parser.add_argument('-file1', '--file1', help='put the name of the first file', type=str, required=True)
parser.add_argument('-file2', '--file2', help='put the name of the second file', type=str, required=True)

args=parser.parse_args()


class json_diffs:
    def __init__(self, json1, json2):
        self.file1 = self.load_json(json1)
        self.file2 = self.load_json(json2)
        self.key_list = self.get_keylist()
        self.check_diff()

    def load_json(self, filename):
        with open(filename, 'r') as file:
            return json.load(file)
        
    def get_keylist(self):
        if len(self.file1) >= len(self.file2):
            return list(self.file1.keys())
        return list(self.file2.keys())


            
    def check_diff(self):
        for key in self.key_list:
            if self.key_in_file(self.file1, key) and self.key_in_file(self.file2, key):
                if self.file1[key] != self.file2[key]:
                    for i in range(len(self.file1[key])):         
                        if self.file1[key][i] != self.file2[key][i]:
                            self.throw_discrepancy(key, i)
            else:
                self.throw_key_inexistent(key)


    def throw_discrepancy(self, key, i):
        print(f"Discrepancy found in {key} for: \n")
        print(self.file1[key][i])
        print(self.file2[key][i])
        print('\n \n')


    def throw_key_inexistent(self, key):
        print(f"Discrepancy found in {key} for:\n")
        if self.key_in_file(self.file1, key):
            print(self.file1[key])
            print("Key does not exist for second file.")
            print('\n \n')
        if self.key_in_file(self.file2, key):
            print("Key does not exist for first file.")
            print(self.file2[key])
            print('\n \n')


    def key_in_file(self, file, key):
        try: 
            file[key]
            return True
        except KeyError:
            return False
        

if __name__ == '__main__':
    json_diffs(json1= args.file1, json2=args.file2)
