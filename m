Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id B2ECB1A1F8C
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 21:21:31 -0700 (PDT)
Date: Wed, 30 Mar 2016 12:19:44 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/5] block, dax: pass blk_dax_ctl through to drivers
Message-ID: <201603301229.Pj7DWz3a%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <1459303190-20072-2-git-send-email-vishal.l.verma@intel.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, kbuild-all@01.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
[also build test ERROR on v4.6-rc1 next-20160329]
[cannot apply to xfs/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Vishal-Verma/dax-handling-of-media-errors/20160330-100409
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-for-next
config: s390-default_defconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=s390 

All error/warnings (new ones prefixed by >>):

   drivers/s390/block/dcssblk.c: In function 'dcssblk_direct_access':
>> drivers/s390/block/dcssblk.c:36:13: error: storage class specified for parameter 'dcssblk_segments'
    static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
                ^
>> drivers/s390/block/dcssblk.c:36:1: error: parameter 'dcssblk_segments' is initialized
    static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
    ^
>> drivers/s390/block/dcssblk.c:38:12: error: storage class specified for parameter 'dcssblk_major'
    static int dcssblk_major;
               ^
>> drivers/s390/block/dcssblk.c:39:45: error: storage class specified for parameter 'dcssblk_devops'
    static const struct block_device_operations dcssblk_devops = {
                                                ^
>> drivers/s390/block/dcssblk.c:39:21: error: parameter 'dcssblk_devops' is initialized
    static const struct block_device_operations dcssblk_devops = {
                        ^
>> drivers/s390/block/dcssblk.c:46:1: warning: empty declaration
    struct dcssblk_dev_info {
    ^
   drivers/s390/block/dcssblk.c:62:1: warning: empty declaration
    struct segment_info {
    ^
>> drivers/s390/block/dcssblk.c:70:16: error: storage class specified for parameter 'dcssblk_add_store'
    static ssize_t dcssblk_add_store(struct device * dev, struct device_attribute *attr, const char * buf,
                   ^
>> drivers/s390/block/dcssblk.c:72:16: error: storage class specified for parameter 'dcssblk_remove_store'
    static ssize_t dcssblk_remove_store(struct device * dev, struct device_attribute *attr, const char * buf,
                   ^
   In file included from include/linux/genhd.h:63:0,
                    from include/linux/blkdev.h:9,
                    from drivers/s390/block/dcssblk.c:16:
>> include/linux/device.h:575:26: error: storage class specified for parameter 'dev_attr_add'
     struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
                             ^
>> drivers/s390/block/dcssblk.c:75:8: note: in expansion of macro 'DEVICE_ATTR'
    static DEVICE_ATTR(add, S_IWUSR, NULL, dcssblk_add_store);
           ^
>> include/linux/device.h:575:9: error: parameter 'dev_attr_add' is initialized
     struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
            ^
>> drivers/s390/block/dcssblk.c:75:8: note: in expansion of macro 'DEVICE_ATTR'
    static DEVICE_ATTR(add, S_IWUSR, NULL, dcssblk_add_store);
           ^
>> include/linux/device.h:575:26: error: storage class specified for parameter 'dev_attr_remove'
     struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
                             ^
   drivers/s390/block/dcssblk.c:76:8: note: in expansion of macro 'DEVICE_ATTR'
    static DEVICE_ATTR(remove, S_IWUSR, NULL, dcssblk_remove_store);
           ^
>> include/linux/device.h:575:9: error: parameter 'dev_attr_remove' is initialized
     struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
            ^
   drivers/s390/block/dcssblk.c:76:8: note: in expansion of macro 'DEVICE_ATTR'
    static DEVICE_ATTR(remove, S_IWUSR, NULL, dcssblk_remove_store);
           ^
>> drivers/s390/block/dcssblk.c:78:23: error: storage class specified for parameter 'dcssblk_root_dev'
    static struct device *dcssblk_root_dev;
                          ^
   In file included from include/linux/module.h:9:0,
                    from drivers/s390/block/dcssblk.c:10:
>> drivers/s390/block/dcssblk.c:80:18: error: storage class specified for parameter 'dcssblk_devices'
    static LIST_HEAD(dcssblk_devices);
                     ^
   include/linux/list.h:23:19: note: in definition of macro 'LIST_HEAD'
     struct list_head name = LIST_HEAD_INIT(name)
                      ^
>> include/linux/list.h:23:9: error: parameter 'dcssblk_devices' is initialized
     struct list_head name = LIST_HEAD_INIT(name)
            ^
>> drivers/s390/block/dcssblk.c:80:8: note: in expansion of macro 'LIST_HEAD'
    static LIST_HEAD(dcssblk_devices);
           ^
>> drivers/s390/block/dcssblk.c:81:28: error: storage class specified for parameter 'dcssblk_devices_sem'
    static struct rw_semaphore dcssblk_devices_sem;
                               ^
>> drivers/s390/block/dcssblk.c:88:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:109:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:136:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:154:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:172:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:189:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:213:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:279:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:315:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   drivers/s390/block/dcssblk.c:324:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
    {
    ^
   In file included from include/linux/genhd.h:63:0,
                    from include/linux/blkdev.h:9,
                    from drivers/s390/block/dcssblk.c:16:

vim +/dcssblk_segments +36 drivers/s390/block/dcssblk.c

^1da177e Linus Torvalds  2005-04-16  23  
^1da177e Linus Torvalds  2005-04-16  24  #define DCSSBLK_NAME "dcssblk"
^1da177e Linus Torvalds  2005-04-16  25  #define DCSSBLK_MINORS_PER_DISK 1
^1da177e Linus Torvalds  2005-04-16  26  #define DCSSBLK_PARM_LEN 400
98df67b3 Kay Sievers     2008-12-25  27  #define DCSS_BUS_ID_SIZE 20
^1da177e Linus Torvalds  2005-04-16  28  
46d74326 Al Viro         2008-03-02 @29  static int dcssblk_open(struct block_device *bdev, fmode_t mode);
db2a144b Al Viro         2013-05-05 @30  static void dcssblk_release(struct gendisk *disk, fmode_t mode);
dece1635 Jens Axboe      2015-11-05  31  static blk_qc_t dcssblk_make_request(struct request_queue *q,
dece1635 Jens Axboe      2015-11-05  32  						struct bio *bio);
e3cb53fb Dan Williams    2016-03-29 @33  static long dcssblk_direct_access(struct block_device *bdev,
e3cb53fb Dan Williams    2016-03-29  34  		struct blk_dax_ctl *dax)
^1da177e Linus Torvalds  2005-04-16  35  
^1da177e Linus Torvalds  2005-04-16 @36  static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
^1da177e Linus Torvalds  2005-04-16  37  
^1da177e Linus Torvalds  2005-04-16 @38  static int dcssblk_major;
83d5cde4 Alexey Dobriyan 2009-09-21 @39  static const struct block_device_operations dcssblk_devops = {
^1da177e Linus Torvalds  2005-04-16  40  	.owner   	= THIS_MODULE,
46d74326 Al Viro         2008-03-02  41  	.open    	= dcssblk_open,
46d74326 Al Viro         2008-03-02  42  	.release 	= dcssblk_release,
420edbcc Carsten Otte    2005-06-23  43  	.direct_access 	= dcssblk_direct_access,
^1da177e Linus Torvalds  2005-04-16  44  };
^1da177e Linus Torvalds  2005-04-16  45  
b2300b9e Hongjie Yang    2008-10-10 @46  struct dcssblk_dev_info {
b2300b9e Hongjie Yang    2008-10-10  47  	struct list_head lh;
b2300b9e Hongjie Yang    2008-10-10  48  	struct device dev;
98df67b3 Kay Sievers     2008-12-25  49  	char segment_name[DCSS_BUS_ID_SIZE];
b2300b9e Hongjie Yang    2008-10-10  50  	atomic_t use_count;
b2300b9e Hongjie Yang    2008-10-10  51  	struct gendisk *gd;
b2300b9e Hongjie Yang    2008-10-10  52  	unsigned long start;
b2300b9e Hongjie Yang    2008-10-10  53  	unsigned long end;
b2300b9e Hongjie Yang    2008-10-10  54  	int segment_type;
b2300b9e Hongjie Yang    2008-10-10  55  	unsigned char save_pending;
b2300b9e Hongjie Yang    2008-10-10  56  	unsigned char is_shared;
b2300b9e Hongjie Yang    2008-10-10  57  	struct request_queue *dcssblk_queue;
b2300b9e Hongjie Yang    2008-10-10  58  	int num_of_segments;
b2300b9e Hongjie Yang    2008-10-10  59  	struct list_head seg_list;
b2300b9e Hongjie Yang    2008-10-10  60  };
b2300b9e Hongjie Yang    2008-10-10  61  
b2300b9e Hongjie Yang    2008-10-10  62  struct segment_info {
b2300b9e Hongjie Yang    2008-10-10  63  	struct list_head lh;
98df67b3 Kay Sievers     2008-12-25  64  	char segment_name[DCSS_BUS_ID_SIZE];
b2300b9e Hongjie Yang    2008-10-10  65  	unsigned long start;
b2300b9e Hongjie Yang    2008-10-10  66  	unsigned long end;
b2300b9e Hongjie Yang    2008-10-10  67  	int segment_type;
b2300b9e Hongjie Yang    2008-10-10  68  };
b2300b9e Hongjie Yang    2008-10-10  69  
e404e274 Yani Ioannou    2005-05-17 @70  static ssize_t dcssblk_add_store(struct device * dev, struct device_attribute *attr, const char * buf,
^1da177e Linus Torvalds  2005-04-16  71  				  size_t count);
e404e274 Yani Ioannou    2005-05-17 @72  static ssize_t dcssblk_remove_store(struct device * dev, struct device_attribute *attr, const char * buf,
^1da177e Linus Torvalds  2005-04-16  73  				  size_t count);
^1da177e Linus Torvalds  2005-04-16  74  
^1da177e Linus Torvalds  2005-04-16 @75  static DEVICE_ATTR(add, S_IWUSR, NULL, dcssblk_add_store);
^1da177e Linus Torvalds  2005-04-16 @76  static DEVICE_ATTR(remove, S_IWUSR, NULL, dcssblk_remove_store);
^1da177e Linus Torvalds  2005-04-16  77  
^1da177e Linus Torvalds  2005-04-16 @78  static struct device *dcssblk_root_dev;
^1da177e Linus Torvalds  2005-04-16  79  
c11ca97e Denis Cheng     2008-01-26 @80  static LIST_HEAD(dcssblk_devices);
^1da177e Linus Torvalds  2005-04-16 @81  static struct rw_semaphore dcssblk_devices_sem;
^1da177e Linus Torvalds  2005-04-16  82  
^1da177e Linus Torvalds  2005-04-16  83  /*
^1da177e Linus Torvalds  2005-04-16  84   * release function for segment device.
^1da177e Linus Torvalds  2005-04-16  85   */
^1da177e Linus Torvalds  2005-04-16  86  static void
^1da177e Linus Torvalds  2005-04-16  87  dcssblk_release_segment(struct device *dev)
^1da177e Linus Torvalds  2005-04-16 @88  {
b2300b9e Hongjie Yang    2008-10-10  89  	struct dcssblk_dev_info *dev_info;
b2300b9e Hongjie Yang    2008-10-10  90  	struct segment_info *entry, *temp;
b2300b9e Hongjie Yang    2008-10-10  91  

:::::: The code at line 36 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
