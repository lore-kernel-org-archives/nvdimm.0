Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EBA173
	for <nvdimm@lists.linux.dev>; Tue, 17 Aug 2021 03:21:23 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238060937"
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="238060937"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 20:21:22 -0700
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="520272465"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 20:21:22 -0700
Date: Mon, 16 Aug 2021 20:21:22 -0700
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
Subject: Re: [PATCH V7 12/18] x86/pks: Add PKS fault callbacks
Message-ID: <20210817032121.GG3169279@iweiny-DESK2.sc.intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-13-ira.weiny@intel.com>
 <1bb543ebdf5458e90bff97698ee3a1cf69f89aa1.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bb543ebdf5458e90bff97698ee3a1cf69f89aa1.camel@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Wed, Aug 11, 2021 at 02:18:26PM -0700, Edgecombe, Rick P wrote:
> On Tue, 2021-08-03 at 21:32 -0700, ira.weiny@intel.com wrote:
> > +static const pks_key_callback
> > pks_key_callbacks[PKS_KEY_NR_CONSUMERS] = { 0 };
> > +
> > +bool handle_pks_key_callback(unsigned long address, bool write, u16
> > key)
> > +{
> > +       if (key > PKS_KEY_NR_CONSUMERS)
> > +               return false;
> Good idea, should be >= though?

Yep.  Fixed thanks.

> 
> > +
> > +       if (pks_key_callbacks[key])
> > +               return pks_key_callbacks[key](address, write);
> > +
> > +       return false;
> > +}
> > +
> 
> Otherwise, I've rebased on this series and didn't hit any problems.
> Thanks.

Awesome!  I still want Dave and Dan to weigh in prior to me respining with the
changes so far.

Thanks,
Ira
