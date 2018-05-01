Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84F6C203B9257
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 15:18:32 -0700 (PDT)
Date: Wed, 2 May 2018 06:17:31 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 4/6] x86, memcpy_mcsafe: define copy_to_iter_mcsafe()
Message-ID: <201805020610.rm0QMt7e%fengguang.wu@intel.com>
References: <152520752986.36522.6608981678390805141.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <152520752986.36522.6608981678390805141.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, kbuild-all@01.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.17-rc3 next-20180501]
[cannot apply to tip/x86/core]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/use-memcpy_mcsafe-for-copy_to_iter/20180502-045742
config: i386-randconfig-s1-201817 (attached as .config)
compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   lib/iov_iter.c: In function 'copyout_mcsafe':
>> lib/iov_iter.c:146:7: error: implicit declaration of function 'copy_to_user_mcsafe' [-Werror=implicit-function-declaration]
      n = copy_to_user_mcsafe((__force void *) to, from, n);
          ^~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/copy_to_user_mcsafe +146 lib/iov_iter.c

   141	
   142	static int copyout_mcsafe(void __user *to, const void *from, size_t n)
   143	{
   144		if (access_ok(VERIFY_WRITE, to, n)) {
   145			kasan_check_read(from, n);
 > 146			n = copy_to_user_mcsafe((__force void *) to, from, n);
   147		}
   148		return n;
   149	}
   150	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
