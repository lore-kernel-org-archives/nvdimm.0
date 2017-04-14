Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail3-relais-sop.national.inria.fr
 (mail3-relais-sop.national.inria.fr [192.134.164.104])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BDFB2194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 08:19:33 -0700 (PDT)
Date: Fri, 14 Apr 2017 17:19:28 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 04/22] target: Make use of the new sg_map function at 16
 call sites (fwd)
Message-ID: <alpine.DEB.2.20.1704141717510.3212@hadrien>
MIME-Version: 1.0
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: kbuild-all@01.org, Steve Wise <swise@opengridcomputing.com>, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, dri-devel@lists.freedesktop.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, linaro-mm-sig@lists.linaro.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

It looks like &udev->cmdr_lock should be released at line 512 if it has
not been released otherwise.  The lock was taken at line 438.

julia

---------- Forwarded message ----------
Date: Fri, 14 Apr 2017 22:21:44 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 04/22] target: Make use of the new sg_map function at 16
    call sites

Hi Logan,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.11-rc6]
[cannot apply to next-20170413]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Logan-Gunthorpe/Introduce-common-scatterlist-map-function/20170414-142518
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
:::::: branch date: 8 hours ago
:::::: commit date: 8 hours ago

>> drivers/target/target_core_user.c:512:2-8: preceding lock on line 438
   drivers/target/target_core_user.c:512:2-8: preceding lock on line 471

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 78082134e7afdc59d744eb8d2def5c588e89c378
vim +512 drivers/target/target_core_user.c

7c9e7a6f Andy Grover      2014-10-01  432  				sizeof(struct tcmu_cmd_entry));
7c9e7a6f Andy Grover      2014-10-01  433  	command_size = base_command_size
7c9e7a6f Andy Grover      2014-10-01  434  		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
7c9e7a6f Andy Grover      2014-10-01  435
7c9e7a6f Andy Grover      2014-10-01  436  	WARN_ON(command_size & (TCMU_OP_ALIGN_SIZE-1));
7c9e7a6f Andy Grover      2014-10-01  437
7c9e7a6f Andy Grover      2014-10-01 @438  	spin_lock_irq(&udev->cmdr_lock);
7c9e7a6f Andy Grover      2014-10-01  439
7c9e7a6f Andy Grover      2014-10-01  440  	mb = udev->mb_addr;
7c9e7a6f Andy Grover      2014-10-01  441  	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
26418649 Sheng Yang       2016-02-26  442  	data_length = se_cmd->data_length;
26418649 Sheng Yang       2016-02-26  443  	if (se_cmd->se_cmd_flags & SCF_BIDI) {
26418649 Sheng Yang       2016-02-26  444  		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
26418649 Sheng Yang       2016-02-26  445  		data_length += se_cmd->t_bidi_data_sg->length;
26418649 Sheng Yang       2016-02-26  446  	}
554617b2 Andy Grover      2016-08-25  447  	if ((command_size > (udev->cmdr_size / 2)) ||
554617b2 Andy Grover      2016-08-25  448  	    data_length > udev->data_size) {
554617b2 Andy Grover      2016-08-25  449  		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
3d9b9555 Andy Grover      2016-08-25  450  			"cmd ring/data area\n", command_size, data_length,
7c9e7a6f Andy Grover      2014-10-01  451  			udev->cmdr_size, udev->data_size);
554617b2 Andy Grover      2016-08-25  452  		spin_unlock_irq(&udev->cmdr_lock);
554617b2 Andy Grover      2016-08-25  453  		return TCM_INVALID_CDB_FIELD;
554617b2 Andy Grover      2016-08-25  454  	}
7c9e7a6f Andy Grover      2014-10-01  455
26418649 Sheng Yang       2016-02-26  456  	while (!is_ring_space_avail(udev, command_size, data_length)) {
7c9e7a6f Andy Grover      2014-10-01  457  		int ret;
7c9e7a6f Andy Grover      2014-10-01  458  		DEFINE_WAIT(__wait);
7c9e7a6f Andy Grover      2014-10-01  459
7c9e7a6f Andy Grover      2014-10-01  460  		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
7c9e7a6f Andy Grover      2014-10-01  461
7c9e7a6f Andy Grover      2014-10-01  462  		pr_debug("sleeping for ring space\n");
7c9e7a6f Andy Grover      2014-10-01  463  		spin_unlock_irq(&udev->cmdr_lock);
7c9e7a6f Andy Grover      2014-10-01  464  		ret = schedule_timeout(msecs_to_jiffies(TCMU_TIME_OUT));
7c9e7a6f Andy Grover      2014-10-01  465  		finish_wait(&udev->wait_cmdr, &__wait);
7c9e7a6f Andy Grover      2014-10-01  466  		if (!ret) {
7c9e7a6f Andy Grover      2014-10-01  467  			pr_warn("tcmu: command timed out\n");
02eb924f Andy Grover      2016-10-06  468  			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
7c9e7a6f Andy Grover      2014-10-01  469  		}
7c9e7a6f Andy Grover      2014-10-01  470
7c9e7a6f Andy Grover      2014-10-01  471  		spin_lock_irq(&udev->cmdr_lock);
7c9e7a6f Andy Grover      2014-10-01  472
7c9e7a6f Andy Grover      2014-10-01  473  		/* We dropped cmdr_lock, cmd_head is stale */
7c9e7a6f Andy Grover      2014-10-01  474  		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
7c9e7a6f Andy Grover      2014-10-01  475  	}
7c9e7a6f Andy Grover      2014-10-01  476
f56574a2 Andy Grover      2014-10-02  477  	/* Insert a PAD if end-of-ring space is too small */
f56574a2 Andy Grover      2014-10-02  478  	if (head_to_end(cmd_head, udev->cmdr_size) < command_size) {
f56574a2 Andy Grover      2014-10-02  479  		size_t pad_size = head_to_end(cmd_head, udev->cmdr_size);
f56574a2 Andy Grover      2014-10-02  480
7c9e7a6f Andy Grover      2014-10-01  481  		entry = (void *) mb + CMDR_OFF + cmd_head;
7c9e7a6f Andy Grover      2014-10-01  482  		tcmu_flush_dcache_range(entry, sizeof(*entry));
0ad46af8 Andy Grover      2015-04-14  483  		tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_PAD);
0ad46af8 Andy Grover      2015-04-14  484  		tcmu_hdr_set_len(&entry->hdr.len_op, pad_size);
0ad46af8 Andy Grover      2015-04-14  485  		entry->hdr.cmd_id = 0; /* not used for PAD */
0ad46af8 Andy Grover      2015-04-14  486  		entry->hdr.kflags = 0;
0ad46af8 Andy Grover      2015-04-14  487  		entry->hdr.uflags = 0;
7c9e7a6f Andy Grover      2014-10-01  488
7c9e7a6f Andy Grover      2014-10-01  489  		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
7c9e7a6f Andy Grover      2014-10-01  490
7c9e7a6f Andy Grover      2014-10-01  491  		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
7c9e7a6f Andy Grover      2014-10-01  492  		WARN_ON(cmd_head != 0);
7c9e7a6f Andy Grover      2014-10-01  493  	}
7c9e7a6f Andy Grover      2014-10-01  494
7c9e7a6f Andy Grover      2014-10-01  495  	entry = (void *) mb + CMDR_OFF + cmd_head;
7c9e7a6f Andy Grover      2014-10-01  496  	tcmu_flush_dcache_range(entry, sizeof(*entry));
0ad46af8 Andy Grover      2015-04-14  497  	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
0ad46af8 Andy Grover      2015-04-14  498  	tcmu_hdr_set_len(&entry->hdr.len_op, command_size);
0ad46af8 Andy Grover      2015-04-14  499  	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
0ad46af8 Andy Grover      2015-04-14  500  	entry->hdr.kflags = 0;
0ad46af8 Andy Grover      2015-04-14  501  	entry->hdr.uflags = 0;
7c9e7a6f Andy Grover      2014-10-01  502
26418649 Sheng Yang       2016-02-26  503  	bitmap_copy(old_bitmap, udev->data_bitmap, DATA_BLOCK_BITS);
26418649 Sheng Yang       2016-02-26  504
3d9b9555 Andy Grover      2016-08-25  505  	/* Handle allocating space from the data area */
7c9e7a6f Andy Grover      2014-10-01  506  	iov = &entry->req.iov[0];
f97ec7db Ilias Tsitsimpis 2015-04-23  507  	iov_cnt = 0;
e4648b01 Ilias Tsitsimpis 2015-04-23  508  	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
e4648b01 Ilias Tsitsimpis 2015-04-23  509  		|| se_cmd->se_cmd_flags & SCF_BIDI);
78082134 Logan Gunthorpe  2017-04-13  510  	if (alloc_and_scatter_data_area(udev, se_cmd->t_data_sg,
78082134 Logan Gunthorpe  2017-04-13  511  		se_cmd->t_data_nents, &iov, &iov_cnt, copy_to_data_area))
78082134 Logan Gunthorpe  2017-04-13 @512  		return TCM_OUT_OF_RESOURCES;
78082134 Logan Gunthorpe  2017-04-13  513
7c9e7a6f Andy Grover      2014-10-01  514  	entry->req.iov_cnt = iov_cnt;
0ad46af8 Andy Grover      2015-04-14  515  	entry->req.iov_dif_cnt = 0;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
