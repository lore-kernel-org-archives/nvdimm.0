Return-Path: <SRS0=r+9T=YU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39469CA9EBE
	for <linux-nvdimm@archiver.kernel.org>; Sun, 27 Oct 2019 21:25:17 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13F002245B
	for <linux-nvdimm@archiver.kernel.org>; Sun, 27 Oct 2019 21:25:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13F002245B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id CE329100EA615;
	Sun, 27 Oct 2019 14:26:12 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.100; helo=mga07.intel.com; envelope-from=lkp@intel.com; receiver=<UNKNOWN> 
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3A6CD100EA611;
	Sun, 27 Oct 2019 14:26:10 -0700 (PDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 14:25:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,237,1569308400";
   d="gz'50?scan'50,208,50";a="211264013"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 27 Oct 2019 14:25:07 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
	(envelope-from <lkp@intel.com>)
	id 1iOq27-00089l-2U; Mon, 28 Oct 2019 05:25:07 +0800
Date: Mon, 28 Oct 2019 05:24:51 +0800
From: kbuild test robot <lkp@intel.com>
To: Alastair D'Silva <alastair@au1.ibm.com>
Subject: Re: [PATCH 04/10] powerpc: Map & release OpenCAPI LPC memory
Message-ID: <201910280525.oZQFx3jR%lkp@intel.com>
References: <20191025044721.16617-5-alastair@au1.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20191025044721.16617-5-alastair@au1.ibm.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Message-ID-Hash: SF2S2C2IWRPVGEPQ3N4M5KOT4A763DO5
X-Message-ID-Hash: SF2S2C2IWRPVGEPQ3N4M5KOT4A763DO5
X-MailFrom: lkp@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Disposition: inline
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
CC: kbuild-all@lists.01.org, alastair@d-silva.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Frederic Barrat <fbarrat@linux.ibm.com>, Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Geert Uytterhoeven <geert+renesas@glider.be>, Krzysztof Kozlowski <krzk@kernel.org>, Anton Blanchard <anton@ozlabs.org>, Allison Randal <allison@lohutok.net>, =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>, David Gibson <david@gibson.dropbear.id.au>, Vasant Hegde <hegdevasant@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Anju T Sudhakar <anju@linux.vnet.ibm.com>, Hari Bathini <hbathini@linux.ibm.com>, Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>, Greg Kurz <groug@kaod.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>
 , Oscar Salvador <osalvador@suse.com>, Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, Wei Yang <richard.weiyang@gmail.com>, Qian Cai <cai@lca.pw>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SF2S2C2IWRPVGEPQ3N4M5KOT4A763DO5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Alastair,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on v5.4-rc5]
[cannot apply to next-20191025]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Alastair-D-Silva/Add-support-for-OpenCAPI-SCM-devices/20191028-043750
base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git da80d2e516eb858eb5bcca7fa5f5a13ed86930e4
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/mmzone.h:811:0,
                    from include/linux/gfp.h:6,
                    from include/linux/mm.h:10,
                    from include/linux/pid_namespace.h:7,
                    from include/linux/ptrace.h:10,
                    from include/linux/audit.h:13,
                    from security/commoncap.c:6:
>> include/linux/memory_hotplug.h:342:5: warning: "CONFIG_MEMORY_HOTPLUG_SPARSE" is not defined, evaluates to 0 [-Wundef]
    #if CONFIG_MEMORY_HOTPLUG_SPARSE
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/mmzone.h:811:0,
                    from include/linux/gfp.h:6,
                    from include/linux/slab.h:15,
                    from include/linux/crypto.h:19,
                    from arch/x86/kernel/asm-offsets.c:9:
>> include/linux/memory_hotplug.h:342:5: warning: "CONFIG_MEMORY_HOTPLUG_SPARSE" is not defined, evaluates to 0 [-Wundef]
    #if CONFIG_MEMORY_HOTPLUG_SPARSE
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   7 real  4 user  3 sys  112.50% cpu 	make prepare

vim +/CONFIG_MEMORY_HOTPLUG_SPARSE +342 include/linux/memory_hotplug.h

   341	
 > 342	#if CONFIG_MEMORY_HOTPLUG_SPARSE
   343	int check_hotplug_memory_addressable(unsigned long pfn,
   344			unsigned long nr_pages);
   345	#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
   346	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
