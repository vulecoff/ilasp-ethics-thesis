nums = [1, 2, [3, 4], [5, 6, 7]]
uid = 0
def parse(nums, pUid):
    global uid

    # print(nums)
    if len(nums) == 0:
        return None
    uid += 1
    if type(nums[0]) is list: 
        localId = uid
        print(nums[0], localId)
        parse(nums[0], localId)
    else:
        print(nums[0], pUid, uid)
    parse(nums[1:], uid)

parse(nums, 0)