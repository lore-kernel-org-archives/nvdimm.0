Return-Path: <SRS0=wyIz=7W=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9F6C433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue,  9 Jun 2020 00:15:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED00A20823
	for <linux-nvdimm@archiver.kernel.org>; Tue,  9 Jun 2020 00:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED00A20823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E984D100978C9;
	Mon,  8 Jun 2020 17:15:32 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.93; helo=mga11.intel.com; envelope-from=lkp@intel.com; receiver=<UNKNOWN> 
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 83770100AA7B6;
	Mon,  8 Jun 2020 17:15:28 -0700 (PDT)
IronPort-SDR: SCcSq1a55xLj98I/dz2S3vD6bljAq1/sfcZ/cM2pDKdYMN9W0Kay6+/svdspV2LKSJM91sBx/5
 TJmWD8DaOtqA==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 17:15:27 -0700
IronPort-SDR: 9vr7aqJAg3E47iSIIgP7ZRXugz/ov06k6VkCmJI0LPSVGM90SmUd7P7uBCpdzwWbe5v1vq+RXR
 067/fP6IAz+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,489,1583222400";
   d="gz'50?scan'50,208,50";a="306102918"
Received: from lkp-server01.sh.intel.com (HELO 12d5c0ac8e64) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 08 Jun 2020 17:15:22 -0700
Received: from kbuild by 12d5c0ac8e64 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1jiRvF-00004r-GG; Tue, 09 Jun 2020 00:15:21 +0000
Date: Tue, 9 Jun 2020 00:59:56 +0800
From: kernel test robot <lkp@intel.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 5/6] ndctl/papr_scm,uapi: Add support for PAPR nvdimm
 specific methods
Message-ID: <202006090059.o4CE5D9b%lkp@intel.com>
References: <20200607131339.476036-6-vaibhav@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20200607131339.476036-6-vaibhav@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: 54MCY32JXBM3L2TGQMEKNYLF26Y563QR
X-Message-ID-Hash: 54MCY32JXBM3L2TGQMEKNYLF26Y563QR
X-MailFrom: lkp@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Disposition: inline
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
CC: kbuild-all@lists.01.org, clang-built-linux@googlegroups.com, Vaibhav Jain <vaibhav@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Steven Rostedt <rostedt@goodmis.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/54MCY32JXBM3L2TGQMEKNYLF26Y563QR/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Vaibhav,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on powerpc/next]
[also build test WARNING on linus/master v5.7 next-20200605]
[cannot apply to linux-nvdimm/libnvdimm-for-next scottwood/next]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Vaibhav-Jain/powerpc-papr_scm-Add-support-for-reporting-nvdimm-health/20200607-211653
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git next
config: powerpc-randconfig-r016-20200607 (attached as .config)
compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project e429cffd4f228f70c1d9df0e5d77c08590dd9766)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>, old ones prefixed by <<):

In file included from <built-in>:1:
>> ./usr/include/asm/papr_pdsm.h:69:20: warning: field 'hdr' with variable sized type 'struct nd_cmd_pkg' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
struct nd_cmd_pkg hdr;  /* Package header containing sub-cmd */
^
1 warning generated.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
