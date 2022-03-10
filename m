Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B677E
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 23:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646953944; x=1678489944;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5QC0vRgugCINeAXN4k7EQqlRq0XcViaqPzPIXBZvqNY=;
  b=htnEhMgB/8JX18HehPurEwiwuR7bpyQElbA3JAT6VyT1UkBDaAt1LsSO
   VLtqkk+2h2qEt2dK7K2/MbNW5TVFSHtjLhpqn/Bs57qyaG1ecR4OJUl0K
   kp+ui/4Ykd/KCnoKpBeUY3AqyHPwjSyCLTZ9+HXcjVfav6txTR1gLdcPJ
   2W5bzdecHa791czprIESRQZvClDoIstYPJDw1F5B1kra1PNOK6Q/3bQEs
   Fs9rrqaBAOxUqFChd9roeCYSGWYF1gLRr3k292lBtHI8yeSNL7j00yUfn
   sm2kmco4zU3CmLLq4WbbHJkJTrzWlYcWQNAsI4dvJ0SYRhfuzsvsklhko
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="236009238"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="236009238"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 15:12:23 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="642757104"
Received: from gdavids1-mobl.amr.corp.intel.com (HELO localhost) ([10.212.65.108])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 15:12:21 -0800
Date: Thu, 10 Mar 2022 15:12:21 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/dax: Fix run_dax() missing prototype
Message-ID: <YiqF1a9VNiSWI5j0@iweiny-desk3>
References: <20220304203756.3487910-1-ira.weiny@intel.com>
 <CAPcyv4juDzD4W_xAff2CdTFzKQhqfFkn93Zo_4Mw23v+Rq=1+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4juDzD4W_xAff2CdTFzKQhqfFkn93Zo_4Mw23v+Rq=1+g@mail.gmail.com>

On Wed, Mar 09, 2022 at 09:08:36PM -0800, Dan Williams wrote:
> On Fri, Mar 4, 2022 at 12:38 PM <ira.weiny@intel.com> wrote:
> >
> > From: Ira Weiny <ira.weiny@intel.com>
> >
> > The function run_dax() was missing a prototype when compiling with
> > warnings.
> >
> > Add bus.h to fix this.
> >
> 
> Always include the warning and the compiler in the changelog.

Sorry.

> I
> suspect you hit this with LLVM and not gcc?

No this was with gcc.

gcc -Wp,-MMD,drivers/dax/.super.o.d -nostdinc -I./arch/x86/include
...
  -D__KBUILD_MODNAME=kmod_dax -c -o drivers/dax/super.o drivers/dax/super.c  ;
  ./tools/objtool/objtool orc generate   --no-fp   --retpoline  --uaccess drivers/dax/super.o
drivers/dax/super.c:276:6: warning: no previous prototype for ‘run_dax’ [-Wmissing-prototypes]
    276 | void run_dax(struct dax_device *dax_dev)
          |      ^~~~~~~

> 
> super.c has no business including bus.h. If the bots are tripping over
> this a better fix is to move it into dax-private.h.

It was not a bot just me using W=1.

I can ignore it or move the prototype to dax-private.h.

Ira
