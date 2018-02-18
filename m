Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64F0521FD73EE
 for <linux-nvdimm@lists.01.org>; Sun, 18 Feb 2018 00:17:43 -0800 (PST)
Date: Sun, 18 Feb 2018 16:22:48 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 2/3] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <201802181615.wTEEGhEQ%fengguang.wu@intel.com>
References: <151871655831.27617.969797567050409931.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
In-Reply-To: <151871655831.27617.969797567050409931.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, kbuild-all@01.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.16-rc1 next-20180216]
[cannot apply to dgc-xfs/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/minimal-DAX-support-for-XFS-realtime-device/20180218-154220
config: i386-randconfig-x003-201807 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings

All warnings (new ones prefixed by >>):

   fs//xfs/xfs_super.c: In function 'xfs_fs_fill_super':
>> fs//xfs/xfs_super.c:1660:8: warning: 'rtdev_is_dax' may be used uninitialized in this function [-Wmaybe-uninitialized]
      bool rtdev_is_dax, datadev_is_dax;
           ^~~~~~~~~~~~

vim +/rtdev_is_dax +1660 fs//xfs/xfs_super.c

  1566	
  1567	STATIC int
  1568	xfs_fs_fill_super(
  1569		struct super_block	*sb,
  1570		void			*data,
  1571		int			silent)
  1572	{
  1573		struct inode		*root;
  1574		struct xfs_mount	*mp = NULL;
  1575		int			flags = 0, error = -ENOMEM;
  1576	
  1577		mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
  1578		if (!mp)
  1579			goto out;
  1580	
  1581		spin_lock_init(&mp->m_sb_lock);
  1582		mutex_init(&mp->m_growlock);
  1583		atomic_set(&mp->m_active_trans, 0);
  1584		INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
  1585		INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
  1586		INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
  1587		mp->m_kobj.kobject.kset = xfs_kset;
  1588	
  1589		mp->m_super = sb;
  1590		sb->s_fs_info = mp;
  1591	
  1592		error = xfs_parseargs(mp, (char *)data);
  1593		if (error)
  1594			goto out_free_fsname;
  1595	
  1596		sb_min_blocksize(sb, BBSIZE);
  1597		sb->s_xattr = xfs_xattr_handlers;
  1598		sb->s_export_op = &xfs_export_operations;
  1599	#ifdef CONFIG_XFS_QUOTA
  1600		sb->s_qcop = &xfs_quotactl_operations;
  1601		sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
  1602	#endif
  1603		sb->s_op = &xfs_super_operations;
  1604	
  1605		if (silent)
  1606			flags |= XFS_MFSI_QUIET;
  1607	
  1608		error = xfs_open_devices(mp);
  1609		if (error)
  1610			goto out_free_fsname;
  1611	
  1612		error = xfs_init_mount_workqueues(mp);
  1613		if (error)
  1614			goto out_close_devices;
  1615	
  1616		error = xfs_init_percpu_counters(mp);
  1617		if (error)
  1618			goto out_destroy_workqueues;
  1619	
  1620		/* Allocate stats memory before we do operations that might use it */
  1621		mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
  1622		if (!mp->m_stats.xs_stats) {
  1623			error = -ENOMEM;
  1624			goto out_destroy_counters;
  1625		}
  1626	
  1627		error = xfs_readsb(mp, flags);
  1628		if (error)
  1629			goto out_free_stats;
  1630	
  1631		error = xfs_finish_flags(mp);
  1632		if (error)
  1633			goto out_free_sb;
  1634	
  1635		error = xfs_setup_devices(mp);
  1636		if (error)
  1637			goto out_free_sb;
  1638	
  1639		error = xfs_filestream_mount(mp);
  1640		if (error)
  1641			goto out_free_sb;
  1642	
  1643		/*
  1644		 * we must configure the block size in the superblock before we run the
  1645		 * full mount process as the mount process can lookup and cache inodes.
  1646		 */
  1647		sb->s_magic = XFS_SB_MAGIC;
  1648		sb->s_blocksize = mp->m_sb.sb_blocksize;
  1649		sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
  1650		sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
  1651		sb->s_max_links = XFS_MAXLINK;
  1652		sb->s_time_gran = 1;
  1653		set_posix_acl_flag(sb);
  1654	
  1655		/* version 5 superblocks support inode version counters. */
  1656		if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
  1657			sb->s_flags |= SB_I_VERSION;
  1658	
  1659		if (mp->m_flags & XFS_MOUNT_DAX) {
> 1660			bool rtdev_is_dax, datadev_is_dax;
  1661	
  1662			xfs_warn(mp,
  1663			"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
  1664	
  1665			datadev_is_dax = bdev_dax_supported(sb,
  1666					mp->m_ddev_targp->bt_bdev, sb->s_blocksize);
  1667			if (mp->m_rtdev_targp)
  1668				rtdev_is_dax = bdev_dax_supported(sb,
  1669						mp->m_rtdev_targp->bt_bdev,
  1670						sb->s_blocksize);
  1671			if (!rtdev_is_dax && !datadev_is_dax) {
  1672				xfs_alert(mp,
  1673				"DAX unsupported by block device. Turning off DAX.");
  1674				mp->m_flags &= ~XFS_MOUNT_DAX;
  1675			}
  1676			if (xfs_sb_version_hasreflink(&mp->m_sb)) {
  1677				xfs_alert(mp,
  1678			"DAX and reflink cannot be used together!");
  1679				error = -EINVAL;
  1680				goto out_filestream_unmount;
  1681			}
  1682		}
  1683	
  1684		if (mp->m_flags & XFS_MOUNT_DISCARD) {
  1685			struct request_queue *q = bdev_get_queue(sb->s_bdev);
  1686	
  1687			if (!blk_queue_discard(q)) {
  1688				xfs_warn(mp, "mounting with \"discard\" option, but "
  1689						"the device does not support discard");
  1690				mp->m_flags &= ~XFS_MOUNT_DISCARD;
  1691			}
  1692		}
  1693	
  1694		if (xfs_sb_version_hasreflink(&mp->m_sb) && mp->m_sb.sb_rblocks) {
  1695			xfs_alert(mp,
  1696		"reflink not compatible with realtime device!");
  1697			error = -EINVAL;
  1698			goto out_filestream_unmount;
  1699		}
  1700	
  1701		if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
  1702			xfs_alert(mp,
  1703		"reverse mapping btree not compatible with realtime device!");
  1704			error = -EINVAL;
  1705			goto out_filestream_unmount;
  1706		}
  1707	
  1708		error = xfs_mountfs(mp);
  1709		if (error)
  1710			goto out_filestream_unmount;
  1711	
  1712		root = igrab(VFS_I(mp->m_rootip));
  1713		if (!root) {
  1714			error = -ENOENT;
  1715			goto out_unmount;
  1716		}
  1717		sb->s_root = d_make_root(root);
  1718		if (!sb->s_root) {
  1719			error = -ENOMEM;
  1720			goto out_unmount;
  1721		}
  1722	
  1723		return 0;
  1724	
  1725	 out_filestream_unmount:
  1726		xfs_filestream_unmount(mp);
  1727	 out_free_sb:
  1728		xfs_freesb(mp);
  1729	 out_free_stats:
  1730		free_percpu(mp->m_stats.xs_stats);
  1731	 out_destroy_counters:
  1732		xfs_destroy_percpu_counters(mp);
  1733	 out_destroy_workqueues:
  1734		xfs_destroy_mount_workqueues(mp);
  1735	 out_close_devices:
  1736		xfs_close_devices(mp);
  1737	 out_free_fsname:
  1738		xfs_free_fsname(mp);
  1739		kfree(mp);
  1740	 out:
  1741		return error;
  1742	
  1743	 out_unmount:
  1744		xfs_filestream_unmount(mp);
  1745		xfs_unmountfs(mp);
  1746		goto out_free_sb;
  1747	}
  1748	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
