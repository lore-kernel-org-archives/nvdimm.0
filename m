Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 969E6209589CC
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 09:02:00 -0700 (PDT)
Date: Thu, 3 Aug 2017 00:02:57 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2] dm: allow device-mapper to operate without dax support
Message-ID: <201708022330.WGRl3jzx%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150162766102.27319.10043964535977848237.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, kbuild-all@01.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on dm/for-next]
[also build test ERROR on v4.13-rc3 next-20170802]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dm-allow-device-mapper-to-operate-without-dax-support/20170802-155255
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: s390-defconfig (attached as .config)
compiler: s390x-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=s390 

All errors (new ones prefixed by >>):

   drivers/md/dm.o: In function `cleanup_mapped_device':
>> drivers/md/dm.c:1684: undefined reference to `kill_dax'
>> drivers/md/dm.c:1685: undefined reference to `put_dax'
   drivers/md/dm.o: In function `close_table_device':
   drivers/md/dm.c:651: undefined reference to `put_dax'
   drivers/md/dm.o: In function `open_table_device':
>> drivers/md/dm.c:637: undefined reference to `dax_get_by_host'
   drivers/md/dm.o: In function `dm_dax_flush':
>> drivers/md/dm.c:1003: undefined reference to `dax_get_private'
   drivers/md/dm.o: In function `dm_dax_copy_from_iter':
   drivers/md/dm.c:979: undefined reference to `dax_get_private'
   drivers/md/dm.o: In function `dm_dax_direct_access':
   drivers/md/dm.c:951: undefined reference to `dax_get_private'
   drivers/md/dm.o: In function `alloc_dev':
>> drivers/md/dm.c:1783: undefined reference to `alloc_dax'
   drivers/md/dm-table.o: In function `device_dax_write_cache_enabled':
   drivers/md/dm-table.c:1644: undefined reference to `dax_write_cache_enabled'
   drivers/md/dm-table.o: In function `dm_table_set_restrictions':
   drivers/md/dm-table.c:1822: undefined reference to `dax_write_cache'
   drivers/md/dm-linear.o: In function `linear_dax_flush':
>> drivers/md/dm-linear.c:197: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-linear.c:199: undefined reference to `dax_flush'
   drivers/md/dm-linear.o: In function `linear_dax_copy_from_iter':
   drivers/md/dm-linear.c:183: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-linear.c:185: undefined reference to `dax_copy_from_iter'
   drivers/md/dm-linear.o: In function `linear_dax_direct_access':
   drivers/md/dm-linear.c:168: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-linear.c:171: undefined reference to `dax_direct_access'
   drivers/md/dm-stripe.o: In function `stripe_dax_flush':
>> drivers/md/dm-stripe.c:369: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-stripe.c:371: undefined reference to `dax_flush'
   drivers/md/dm-stripe.o: In function `stripe_dax_copy_from_iter':
   drivers/md/dm-stripe.c:350: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-stripe.c:352: undefined reference to `dax_copy_from_iter'
   drivers/md/dm-stripe.o: In function `stripe_dax_direct_access':
   drivers/md/dm-stripe.c:330: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-stripe.c:333: undefined reference to `dax_direct_access'

vim +1684 drivers/md/dm.c

4a0b4ddf2 Mike Snitzer        2010-08-12  1672  
0f20972f7 Mike Snitzer        2015-04-28  1673  static void cleanup_mapped_device(struct mapped_device *md)
0f20972f7 Mike Snitzer        2015-04-28  1674  {
0f20972f7 Mike Snitzer        2015-04-28  1675  	if (md->wq)
0f20972f7 Mike Snitzer        2015-04-28  1676  		destroy_workqueue(md->wq);
0f20972f7 Mike Snitzer        2015-04-28  1677  	if (md->kworker_task)
0f20972f7 Mike Snitzer        2015-04-28  1678  		kthread_stop(md->kworker_task);
0f20972f7 Mike Snitzer        2015-04-28  1679  	mempool_destroy(md->io_pool);
0f20972f7 Mike Snitzer        2015-04-28  1680  	if (md->bs)
0f20972f7 Mike Snitzer        2015-04-28  1681  		bioset_free(md->bs);
0f20972f7 Mike Snitzer        2015-04-28  1682  
f26c5719b Dan Williams        2017-04-12  1683  	if (md->dax_dev) {
f26c5719b Dan Williams        2017-04-12 @1684  		kill_dax(md->dax_dev);
f26c5719b Dan Williams        2017-04-12 @1685  		put_dax(md->dax_dev);
f26c5719b Dan Williams        2017-04-12  1686  		md->dax_dev = NULL;
f26c5719b Dan Williams        2017-04-12  1687  	}
f26c5719b Dan Williams        2017-04-12  1688  
0f20972f7 Mike Snitzer        2015-04-28  1689  	if (md->disk) {
0f20972f7 Mike Snitzer        2015-04-28  1690  		spin_lock(&_minor_lock);
0f20972f7 Mike Snitzer        2015-04-28  1691  		md->disk->private_data = NULL;
0f20972f7 Mike Snitzer        2015-04-28  1692  		spin_unlock(&_minor_lock);
0f20972f7 Mike Snitzer        2015-04-28  1693  		del_gendisk(md->disk);
0f20972f7 Mike Snitzer        2015-04-28  1694  		put_disk(md->disk);
0f20972f7 Mike Snitzer        2015-04-28  1695  	}
0f20972f7 Mike Snitzer        2015-04-28  1696  
0f20972f7 Mike Snitzer        2015-04-28  1697  	if (md->queue)
0f20972f7 Mike Snitzer        2015-04-28  1698  		blk_cleanup_queue(md->queue);
0f20972f7 Mike Snitzer        2015-04-28  1699  
d09960b00 Tahsin Erdogan      2016-10-10  1700  	cleanup_srcu_struct(&md->io_barrier);
d09960b00 Tahsin Erdogan      2016-10-10  1701  
0f20972f7 Mike Snitzer        2015-04-28  1702  	if (md->bdev) {
0f20972f7 Mike Snitzer        2015-04-28  1703  		bdput(md->bdev);
0f20972f7 Mike Snitzer        2015-04-28  1704  		md->bdev = NULL;
0f20972f7 Mike Snitzer        2015-04-28  1705  	}
4cc96131a Mike Snitzer        2016-05-12  1706  
4cc96131a Mike Snitzer        2016-05-12  1707  	dm_mq_cleanup_mapped_device(md);
0f20972f7 Mike Snitzer        2015-04-28  1708  }
0f20972f7 Mike Snitzer        2015-04-28  1709  
^1da177e4 Linus Torvalds      2005-04-16  1710  /*
^1da177e4 Linus Torvalds      2005-04-16  1711   * Allocate and initialise a blank device with a given minor.
^1da177e4 Linus Torvalds      2005-04-16  1712   */
2b06cfff1 Alasdair G Kergon   2006-06-26  1713  static struct mapped_device *alloc_dev(int minor)
^1da177e4 Linus Torvalds      2005-04-16  1714  {
115485e83 Mike Snitzer        2016-02-22  1715  	int r, numa_node_id = dm_get_numa_node();
74f22ed6b Dan Williams        2017-08-01  1716  	struct dax_device *dax_dev = NULL;
115485e83 Mike Snitzer        2016-02-22  1717  	struct mapped_device *md;
ba61fdd17 Jeff Mahoney        2006-06-26  1718  	void *old_md;
^1da177e4 Linus Torvalds      2005-04-16  1719  
115485e83 Mike Snitzer        2016-02-22  1720  	md = kzalloc_node(sizeof(*md), GFP_KERNEL, numa_node_id);
^1da177e4 Linus Torvalds      2005-04-16  1721  	if (!md) {
^1da177e4 Linus Torvalds      2005-04-16  1722  		DMWARN("unable to allocate device, out of memory.");
^1da177e4 Linus Torvalds      2005-04-16  1723  		return NULL;
^1da177e4 Linus Torvalds      2005-04-16  1724  	}
^1da177e4 Linus Torvalds      2005-04-16  1725  
10da4f795 Jeff Mahoney        2006-06-26  1726  	if (!try_module_get(THIS_MODULE))
6ed7ade89 Milan Broz          2008-02-08  1727  		goto bad_module_get;
10da4f795 Jeff Mahoney        2006-06-26  1728  
^1da177e4 Linus Torvalds      2005-04-16  1729  	/* get a minor number for the dev */
2b06cfff1 Alasdair G Kergon   2006-06-26  1730  	if (minor == DM_ANY_MINOR)
cf13ab8e0 Frederik Deweerdt   2008-04-24  1731  		r = next_free_minor(&minor);
2b06cfff1 Alasdair G Kergon   2006-06-26  1732  	else
cf13ab8e0 Frederik Deweerdt   2008-04-24  1733  		r = specific_minor(minor);
^1da177e4 Linus Torvalds      2005-04-16  1734  	if (r < 0)
6ed7ade89 Milan Broz          2008-02-08  1735  		goto bad_minor;
^1da177e4 Linus Torvalds      2005-04-16  1736  
83d5e5b0a Mikulas Patocka     2013-07-10  1737  	r = init_srcu_struct(&md->io_barrier);
83d5e5b0a Mikulas Patocka     2013-07-10  1738  	if (r < 0)
83d5e5b0a Mikulas Patocka     2013-07-10  1739  		goto bad_io_barrier;
83d5e5b0a Mikulas Patocka     2013-07-10  1740  
115485e83 Mike Snitzer        2016-02-22  1741  	md->numa_node_id = numa_node_id;
4cc96131a Mike Snitzer        2016-05-12  1742  	md->use_blk_mq = dm_use_blk_mq_default();
591ddcfc4 Mike Snitzer        2016-01-31  1743  	md->init_tio_pdu = false;
a5664dad7 Mike Snitzer        2010-08-12  1744  	md->type = DM_TYPE_NONE;
e61290a4a Daniel Walker       2008-02-08  1745  	mutex_init(&md->suspend_lock);
a5664dad7 Mike Snitzer        2010-08-12  1746  	mutex_init(&md->type_lock);
86f1152b1 Benjamin Marzinski  2014-08-13  1747  	mutex_init(&md->table_devices_lock);
022c26110 Mikulas Patocka     2009-04-02  1748  	spin_lock_init(&md->deferred_lock);
^1da177e4 Linus Torvalds      2005-04-16  1749  	atomic_set(&md->holders, 1);
5c6bd75d0 Alasdair G Kergon   2006-06-26  1750  	atomic_set(&md->open_count, 0);
^1da177e4 Linus Torvalds      2005-04-16  1751  	atomic_set(&md->event_nr, 0);
7a8c3d3b9 Mike Anderson       2007-10-19  1752  	atomic_set(&md->uevent_seq, 0);
7a8c3d3b9 Mike Anderson       2007-10-19  1753  	INIT_LIST_HEAD(&md->uevent_list);
86f1152b1 Benjamin Marzinski  2014-08-13  1754  	INIT_LIST_HEAD(&md->table_devices);
7a8c3d3b9 Mike Anderson       2007-10-19  1755  	spin_lock_init(&md->uevent_lock);
^1da177e4 Linus Torvalds      2005-04-16  1756  
115485e83 Mike Snitzer        2016-02-22  1757  	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id);
^1da177e4 Linus Torvalds      2005-04-16  1758  	if (!md->queue)
0f20972f7 Mike Snitzer        2015-04-28  1759  		goto bad;
^1da177e4 Linus Torvalds      2005-04-16  1760  
4a0b4ddf2 Mike Snitzer        2010-08-12  1761  	dm_init_md_queue(md);
9faf400f7 Stefan Bader        2006-10-03  1762  
115485e83 Mike Snitzer        2016-02-22  1763  	md->disk = alloc_disk_node(1, numa_node_id);
^1da177e4 Linus Torvalds      2005-04-16  1764  	if (!md->disk)
0f20972f7 Mike Snitzer        2015-04-28  1765  		goto bad;
^1da177e4 Linus Torvalds      2005-04-16  1766  
316d315bf Nikanth Karthikesan 2009-10-06  1767  	atomic_set(&md->pending[0], 0);
316d315bf Nikanth Karthikesan 2009-10-06  1768  	atomic_set(&md->pending[1], 0);
f0b041153 Jeff Mahoney        2006-06-26  1769  	init_waitqueue_head(&md->wait);
53d5914f2 Mikulas Patocka     2009-04-02  1770  	INIT_WORK(&md->work, dm_wq_work);
f0b041153 Jeff Mahoney        2006-06-26  1771  	init_waitqueue_head(&md->eventq);
2995fa78e Mikulas Patocka     2014-01-13  1772  	init_completion(&md->kobj_holder.completion);
2eb6e1e3a Keith Busch         2014-10-17  1773  	md->kworker_task = NULL;
f0b041153 Jeff Mahoney        2006-06-26  1774  
^1da177e4 Linus Torvalds      2005-04-16  1775  	md->disk->major = _major;
^1da177e4 Linus Torvalds      2005-04-16  1776  	md->disk->first_minor = minor;
^1da177e4 Linus Torvalds      2005-04-16  1777  	md->disk->fops = &dm_blk_dops;
^1da177e4 Linus Torvalds      2005-04-16  1778  	md->disk->queue = md->queue;
^1da177e4 Linus Torvalds      2005-04-16  1779  	md->disk->private_data = md;
^1da177e4 Linus Torvalds      2005-04-16  1780  	sprintf(md->disk->disk_name, "dm-%d", minor);
f26c5719b Dan Williams        2017-04-12  1781  
74f22ed6b Dan Williams        2017-08-01  1782  	if (IS_ENABLED(CONFIG_DAX)) {
f26c5719b Dan Williams        2017-04-12 @1783  		dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
f26c5719b Dan Williams        2017-04-12  1784  		if (!dax_dev)
f26c5719b Dan Williams        2017-04-12  1785  			goto bad;
74f22ed6b Dan Williams        2017-08-01  1786  	}
f26c5719b Dan Williams        2017-04-12  1787  	md->dax_dev = dax_dev;
f26c5719b Dan Williams        2017-04-12  1788  
^1da177e4 Linus Torvalds      2005-04-16  1789  	add_disk(md->disk);
7e51f257e Mike Anderson       2006-03-27  1790  	format_dev_t(md->name, MKDEV(_major, minor));
^1da177e4 Linus Torvalds      2005-04-16  1791  
670368a8d Tejun Heo           2013-07-30  1792  	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
304f3f6a5 Milan Broz          2008-02-08  1793  	if (!md->wq)
0f20972f7 Mike Snitzer        2015-04-28  1794  		goto bad;
304f3f6a5 Milan Broz          2008-02-08  1795  
32a926da5 Mikulas Patocka     2009-06-22  1796  	md->bdev = bdget_disk(md->disk, 0);
32a926da5 Mikulas Patocka     2009-06-22  1797  	if (!md->bdev)
0f20972f7 Mike Snitzer        2015-04-28  1798  		goto bad;
32a926da5 Mikulas Patocka     2009-06-22  1799  
3a83f4677 Ming Lei            2016-11-22  1800  	bio_init(&md->flush_bio, NULL, 0);
6a8736d10 Tejun Heo           2010-09-08  1801  	md->flush_bio.bi_bdev = md->bdev;
ff0361b34 Jan Kara            2017-05-31  1802  	md->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
6a8736d10 Tejun Heo           2010-09-08  1803  
fd2ed4d25 Mikulas Patocka     2013-08-16  1804  	dm_stats_init(&md->stats);
fd2ed4d25 Mikulas Patocka     2013-08-16  1805  
ba61fdd17 Jeff Mahoney        2006-06-26  1806  	/* Populate the mapping, nobody knows we exist yet */
f32c10b09 Jeff Mahoney        2006-06-26  1807  	spin_lock(&_minor_lock);
ba61fdd17 Jeff Mahoney        2006-06-26  1808  	old_md = idr_replace(&_minor_idr, md, minor);
f32c10b09 Jeff Mahoney        2006-06-26  1809  	spin_unlock(&_minor_lock);
ba61fdd17 Jeff Mahoney        2006-06-26  1810  
ba61fdd17 Jeff Mahoney        2006-06-26  1811  	BUG_ON(old_md != MINOR_ALLOCED);
ba61fdd17 Jeff Mahoney        2006-06-26  1812  
^1da177e4 Linus Torvalds      2005-04-16  1813  	return md;
^1da177e4 Linus Torvalds      2005-04-16  1814  
0f20972f7 Mike Snitzer        2015-04-28  1815  bad:
0f20972f7 Mike Snitzer        2015-04-28  1816  	cleanup_mapped_device(md);
83d5e5b0a Mikulas Patocka     2013-07-10  1817  bad_io_barrier:
^1da177e4 Linus Torvalds      2005-04-16  1818  	free_minor(minor);
6ed7ade89 Milan Broz          2008-02-08  1819  bad_minor:
10da4f795 Jeff Mahoney        2006-06-26  1820  	module_put(THIS_MODULE);
6ed7ade89 Milan Broz          2008-02-08  1821  bad_module_get:
^1da177e4 Linus Torvalds      2005-04-16  1822  	kfree(md);
^1da177e4 Linus Torvalds      2005-04-16  1823  	return NULL;
^1da177e4 Linus Torvalds      2005-04-16  1824  }
^1da177e4 Linus Torvalds      2005-04-16  1825  

:::::: The code at line 1684 was first introduced by commit
:::::: f26c5719b2d7b00de69eb83eb1c1c831759fdc9b dm: add dax_device and dax_operations support

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
