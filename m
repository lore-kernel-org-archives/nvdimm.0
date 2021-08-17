Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4DA173
	for <nvdimm@lists.linux.dev>; Tue, 17 Aug 2021 03:12:43 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203184452"
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="203184452"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 20:12:42 -0700
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="530849800"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 20:12:42 -0700
Date: Mon, 16 Aug 2021 20:12:42 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"Lutomirski, Andy" <luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH V7 14/18] memremap_pages: Add memremap.pks_fault_mode
Message-ID: <20210817031242.GF3169279@iweiny-DESK2.sc.intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-15-ira.weiny@intel.com>
 <506157336072463bf08562176eff0bb068cd0e9d.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506157336072463bf08562176eff0bb068cd0e9d.camel@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Wed, Aug 11, 2021 at 12:01:28PM -0700, Edgecombe, Rick P wrote:
> On Tue, 2021-08-03 at 21:32 -0700, ira.weiny@intel.com wrote:
> > +static int param_set_pks_fault_mode(const char *val, const struct
> > kernel_param *kp)
> > +{
> > +       int ret = -EINVAL;
> > +
> > +       if (!sysfs_streq(val, "relaxed")) {
> > +               pks_fault_mode = PKS_MODE_RELAXED;
> > +               ret = 0;
> > +       } else if (!sysfs_streq(val, "strict")) {
> > +               pks_fault_mode = PKS_MODE_STRICT;
> > +               ret = 0;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> 
> Looks like !sysfs_streq() should be just sysfs_streq().

Indeed. Fixed.

Thanks!
Ira

