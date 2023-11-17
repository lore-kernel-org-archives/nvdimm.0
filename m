Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054463EA9A
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjshloEc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700239960; x=1731775960;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EsZC9L15hL4j222W+J+HYHH/hDk0zmCMIDoZCGK30i0=;
  b=fjshloEcdQ/NXXOAgDhm3ihn/ky557SVWFWHwqfmcjIBDCYkRxueuNlv
   Ig75fzvqxhtvgCPC8lIdJ7Bw081WuPyDVCgDjhaA00mZrBjH05PgEaTDc
   lGy4/1d66zrzojFVPjpDa4qBKuyymR1MHpefUHaoetok49MOwKjPOkOkc
   5NRnvaSv/jbBDnM/Nw9BSX+j59Ed7DOo+cTclNZSYmhMAJVJkC2iOpGRy
   rUSzihobKlqRJDh5ZPdCqJr/sLQkwCxk2DMYm0UfcClkKGZnHOjw5yKdJ
   2oYKhtt8QBnJmB6p/f465EBCeX2D5b5UL8LjskwTIzkaQVoqvQbcY8RU0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="12879983"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="12879983"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 08:52:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="742117065"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="742117065"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.86.159])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 08:52:38 -0800
Date: Fri, 17 Nov 2023 08:52:37 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 5/5] cxl/test: add cxl-poison.sh unit test
Message-ID: <ZVeaVTCKqjQ9u8nw@aschofie-mobl2>
References: <cover.1696196382.git.alison.schofield@intel.com>
 <51fdd212d139d203506cc2ee18abb362e5859e3e.1696196382.git.alison.schofield@intel.com>
 <6bbc779c174fc03f01382666b4b6b44fdfc0ef8c.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bbc779c174fc03f01382666b4b6b44fdfc0ef8c.camel@intel.com>

On Wed, Nov 15, 2023 at 02:13:48AM -0800, Vishal Verma wrote:
> On Sun, 2023-10-01 at 15:31 -0700, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Exercise cxl list, libcxl, and driver pieces of the get poison list
> > pathway. Inject and clear poison using debugfs and use cxl-cli to
> > read the poison list by memdev and by region.
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---

snip

> > +cxl list
> 
> "$CXL" list
> 
> Also should reset rc from 77 so that it doesn't show as skipped on a
> real failure.

Done.

>
snip

> > +setup_x2_region()
> > +{
> > +        # Find an x2 decoder
> > +        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> 
> I suspect this comes from another test, but test/common defines a
> $cxl_test_bus that can be used here.

Done.

> 
snip

> > +find_media_errors()
> > +{
> > +       nr=$(echo $json | jq -r ".nr_poison_records")
> 
> No need for echo and pipe -
> 
>   nr="$(jq -r ".nr_poison_records" <<< "$json")"

Done

> 
> Also, this currently assumes that a global '$json' will be available
> and up to date. In this test the way it is called, this will always be
> true, but it would be cleaner to actually pass $json to
> find_media_errors() each time, and in here, do something like
> 
>   local json="$1"
> 

Done

> > +       if [[ $nr -ne $NR_ERRS ]]; then
> 
> If using the bash variant, [[ ]], this should be
> 
>   if [[ $nr != $NR_ERRS ]]; then
> 

Done

> > +               echo "$mem: $NR_ERRS poison records expected, $nr found"
> > +               err "$LINENO"
> > +       fi
> > +}
> > +
snip

> > +find_media_errors
> 
> For all of the above debugfs writes -
> 
> mem1 is hard-coded - is this supposed to be "$mem1" from when
> setup_x2_region() was done (similar to how the region stuff is done
> below)?

It was intentionally hardcoded based on what I expect in the
cxl-test topology. 

Changed it in v3 to look up a memdev.

> 
> > +
> > +# Poison by region: inject, list, clear, list.
> > +setup_x2_region
> > +create_region
> > +echo 0x40000000 > /sys/kernel/debug/cxl/"$mem0"/inject_poison
> > +echo 0x40000000 > /sys/kernel/debug/cxl/"$mem1"/inject_poison
> > +NR_ERRS=2
> > +json=$("$CXL" list -r "$region" --poison | jq -r '.[].poison')
> > +find_media_errors
> > +echo 0x40000000 > /sys/kernel/debug/cxl/"$mem0"/clear_poison
> > +echo 0x40000000 > /sys/kernel/debug/cxl/"$mem1"/clear_poison
> 
> It might be nice to create a couple of helpers -
> 
>   inject_poison_sysfs() {
>     memdev="$1"
>     addr="$2
>     ...
>   }
> 
> And similarly
> 
>   clear_poison_sysfs()...
>

Done

Thanks for the review Vishal, especially the bash & jq wisdom!
> >

