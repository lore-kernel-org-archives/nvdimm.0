Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D628B21A04822
 for <linux-nvdimm@lists.01.org>; Sat, 29 Apr 2017 01:46:45 -0700 (PDT)
Date: Sat, 29 Apr 2017 16:46:10 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/3] virtio, rpmsg: switch to dynamic_hex_dump()
Message-ID: <201704291610.sI4vYOud%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <149341494418.35578.561981766577089185.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-nvdimm@lists.01.org, linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-acpi@vger.kernel.org, kbuild-all@01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on pm/linux-next]
[also build test ERROR on v4.11-rc8 next-20170428]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dynamic_hex_dump-cleanup/20170429-135503
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
config: arm-multi_v7_defconfig (attached as .config)
compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=arm 

All errors (new ones prefixed by >>):

   drivers//rpmsg/virtio_rpmsg_bus.c: In function 'rpmsg_send_offchannel_raw':
>> drivers//rpmsg/virtio_rpmsg_bus.c:602:2: error: implicit declaration of function 'dynamic_hex_dump' [-Werror=implicit-function-declaration]
     dynamic_hex_dump("rpmsg_virtio TX: ", DUMP_PREFIX_NONE, 16, 1,
     ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/dynamic_hex_dump +602 drivers//rpmsg/virtio_rpmsg_bus.c

bcabbcca Ohad Ben-Cohen 2011-10-20  596  	msg->dst = dst;
bcabbcca Ohad Ben-Cohen 2011-10-20  597  	msg->reserved = 0;
bcabbcca Ohad Ben-Cohen 2011-10-20  598  	memcpy(msg->data, data, len);
bcabbcca Ohad Ben-Cohen 2011-10-20  599  
bcabbcca Ohad Ben-Cohen 2011-10-20  600  	dev_dbg(dev, "TX From 0x%x, To 0x%x, Len %d, Flags %d, Reserved %d\n",
0963679c Anna, Suman    2016-08-12  601  		msg->src, msg->dst, msg->len, msg->flags, msg->reserved);
211e3a93 Anna, Suman    2016-08-12 @602  	dynamic_hex_dump("rpmsg_virtio TX: ", DUMP_PREFIX_NONE, 16, 1,
bcabbcca Ohad Ben-Cohen 2011-10-20  603  			 msg, sizeof(*msg) + msg->len, true);
bcabbcca Ohad Ben-Cohen 2011-10-20  604  
bcabbcca Ohad Ben-Cohen 2011-10-20  605  	sg_init_one(&sg, msg, sizeof(*msg) + len);

:::::: The code at line 602 was first introduced by commit
:::::: 211e3a93e5b5933e64ddfb299eee462ac7c7d500 rpmsg: use dynamic_hex_dump for hex dump traces

:::::: TO: Anna, Suman <s-anna@ti.com>
:::::: CC: Bjorn Andersson <bjorn.andersson@linaro.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
