Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A22EC821A8
 for <linux-nvdimm@lists.01.org>; Tue, 13 Dec 2016 03:42:12 -0800 (PST)
Date: Tue, 13 Dec 2016 12:42:08 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [LKP] [ext4] e2ae766c1b:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c
Message-ID: <20161213114208.GF15362@quack2.suse.cz>
References: <20161212101321.GA37214@inn.lkp.intel.com>
 <20161212163518.GA20728@quack2.suse.cz>
 <87mvg08voo.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mvg08voo.fsf@yhuang-dev.intel.com>
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
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, kernel test robot <xiaolong.ye@intel.com>, LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, lkp@01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 13-12-16 09:27:51, Huang, Ying wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Mon 12-12-16 18:13:21, kernel test robot wrote:
> >> FYI, we noticed the following commit:
> >> 
> >> commit: e2ae766c1b030271b5099b25674e2131d1d1e8c1 ("ext4: convert DAX faults to iomap infrastructure")
> >> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> >> 
> >> in testcase: nvml
> >> with following parameters:
> >> 
> >> 	group: vmem
> >> 	test: pmem
> >> 	nr_pmem: 1
> >> 	fs: ext4
> >> 	mount_option: dax
> >> 
> >> 
> >> 
> >> on test machine: 64 threads Intel(R) Xeon(R) CPU E5-4650 0 @ 2.70GHz with 64G memory
> >> 
> >> caused below changes:
> >> 
> >> 
> >> +------------------------------------------------+------------+------------+
> >> |                                                | 96f8ba3dd6 | e2ae766c1b |
> >> +------------------------------------------------+------------+------------+
> >> | boot_successes                                 | 2          | 2          |
> >> | boot_failures                                  | 2          | 2          |
> >> | BUG:kernel_hang_in_test_stage                  | 2          |            |
> >> | WARNING:at_fs/sysfs/dir.c:#sysfs_warn_dup      | 0          | 2          |
> >> | calltrace:parport_pc_init                      | 0          | 2          |
> >> | calltrace:SyS_finit_module                     | 0          | 2          |
> >> | WARNING:at_lib/kobject.c:#kobject_add_internal | 0          | 2          |
> >> +------------------------------------------------+------------+------------+
> >> 
> >> 
> >> 
> >> user  :notice: [  325.592182] vmem_aligned_alloc/TEST1: SETUP (check/pmem/debug)
> >> 
> >> user  :notice: [  325.603973] vmem_aligned_alloc/TEST1: START: vmem_aligned_alloc
> >> kern  :err   : [  325.608906] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:51
> >> kern  :err   : [  325.608908] in_atomic(): 1, irqs_disabled(): 0, pid: 24813, name: vmem_aligned_al
> >> kern  :warn  : [  325.608914] CPU: 44 PID: 24813 Comm: vmem_aligned_al Tainted: G           O    4.9.0-rc4-00045-ge2ae766 #1
> >> kern  :warn  : [  325.608916] Hardware name: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
> >> kern  :warn  : [  325.608922]  ffffc9002c1f7be0
> >> kern  :warn  : [  325.608923]  ffffffff81466af9
> >> kern  :warn  : [  325.608924]  ffff880fea2425c0
> >
> > I think this is actually a bug introduced by Ross' PMD support. Attached
> > patch should fix it. Ross, can you check it please?
> 
> Hi, Jan
> 
> Could you provide a git tree commit for me to test it?  If you want it
> to be tested by 0day.

Thanks for the offer! I've pushed out the latest version of my DAX patches
including the above fix to

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dax

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
