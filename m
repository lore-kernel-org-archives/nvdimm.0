Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 48A0D1A1E4A
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 15:02:40 -0700 (PDT)
Date: Sun, 5 Jun 2016 05:50:23 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 01/13] driver core, libnvdimm: disable manual unbind of
 dimms while region active
Message-ID: <201606050515.hLdjF7bG%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <146507355828.8347.11600179233094511139.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, david@fromorbit.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test WARNING on v4.7-rc1]
[also build test WARNING on next-20160603]
[cannot apply to linux-nvdimm/libnvdimm-for-next tip/x86/core]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/deprecate-pcommit/20160605-045935
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/init.h:1: warning: no structured comments found
   kernel/sched/core.c:2079: warning: No description found for parameter 'cookie'
   kernel/sys.c:1: warning: no structured comments found
>> include/linux/device.h:856: warning: No description found for parameter 'suppress_unbind_attr'
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   include/linux/fence.h:84: warning: No description found for parameter 'child_list'
   include/linux/fence.h:84: warning: No description found for parameter 'active_list'
   drivers/dma-buf/reservation.c:1: warning: no structured comments found
   include/linux/reservation.h:1: warning: no structured comments found

vim +/suppress_unbind_attr +856 include/linux/device.h

929d2fa5 Matthew Wilcox     2008-10-16  840  	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
ca22e56d Kay Sievers        2011-12-14  841  	u32			id;	/* device instance */
929d2fa5 Matthew Wilcox     2008-10-16  842  
9ac7849e Tejun Heo          2007-01-20  843  	spinlock_t		devres_lock;
9ac7849e Tejun Heo          2007-01-20  844  	struct list_head	devres_head;
9ac7849e Tejun Heo          2007-01-20  845  
5a3ceb86 Tejun Heo          2008-08-25  846  	struct klist_node	knode_class;
b7a3e813 Kay Sievers        2006-10-07  847  	struct class		*class;
a4dbd674 David Brownell     2009-06-24  848  	const struct attribute_group **groups;	/* optional groups */
23681e47 Greg Kroah-Hartman 2006-06-14  849  
^1da177e Linus Torvalds     2005-04-16  850  	void	(*release)(struct device *dev);
74416e1e Alex Williamson    2012-05-30  851  	struct iommu_group	*iommu_group;
031a8908 Dan Williams       2016-06-04  852  	atomic_t		suppress_unbind_attr; /* disable manual unbind */
4f3549d7 Rafael J. Wysocki  2013-05-02  853  
4f3549d7 Rafael J. Wysocki  2013-05-02  854  	bool			offline_disabled:1;
4f3549d7 Rafael J. Wysocki  2013-05-02  855  	bool			offline:1;
^1da177e Linus Torvalds     2005-04-16 @856  };
^1da177e Linus Torvalds     2005-04-16  857  
a4232963 Lars-Peter Clausen 2012-07-03  858  static inline struct device *kobj_to_dev(struct kobject *kobj)
a4232963 Lars-Peter Clausen 2012-07-03  859  {
a4232963 Lars-Peter Clausen 2012-07-03  860  	return container_of(kobj, struct device, kobj);
a4232963 Lars-Peter Clausen 2012-07-03  861  }
a4232963 Lars-Peter Clausen 2012-07-03  862  
9a3df1f7 Alan Stern         2008-03-19  863  /* Get the wakeup routines, which depend on struct device */
9a3df1f7 Alan Stern         2008-03-19  864  #include <linux/pm_wakeup.h>

:::::: The code at line 856 was first introduced by commit
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
