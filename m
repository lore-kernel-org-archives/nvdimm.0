Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6148C0B
	for <nvdimm@lists.linux.dev>; Tue, 21 Feb 2023 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677004443; x=1708540443;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W2DgoNIBqTUdR7cgxM9iP9YdGTsBiPVZAd1W8LNrPWw=;
  b=ClKsthNN9Tz5lpJmBEWWR5PU0Z1JFmHCtmrhoucLMJcSU9zDukk1Hs/1
   VnG2FwaeJoZh1eslbxS8wr/joDXMFSLvqN5/LetfDxzaquSoC/3sjfh0W
   K4ywYQXDQ/FyhwCQmtVVZsKxKLE3Pq7T0B8WpRAEMw4+syCnrcSHM+XXA
   bHv1LOOe4+lAFW/PRmOk5Q2d1XFLRrdSpSl20kNSs79UHr2qbl5Sj6JoK
   WnBqsxDbl9l++B372R+/vQnbA6RoOgGPmXiHcyox7mTk9MCTFrZgpjjgx
   MJCVx3oYdkaNh2FwZ/yF3uDnlF+f6jfbzAbquOB57DYAsnFRRLQ0oEp2w
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="330440257"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="330440257"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 10:34:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="814606621"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="814606621"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.28.85])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 10:34:02 -0800
Date: Tue, 21 Feb 2023 10:34:00 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 3/3] test/cxl-security.sh: avoid intermittent
 failures due to sasync probe
Message-ID: <Y/UOmFaOtx9FOnwf@aschofie-mobl2>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-3-043fac896a40@intel.com>
 <Y/T96khZVa7Oo6uU@aschofie-mobl2>
 <427fbc8d0cf56b9cbdfb7f5bef31a96c4b40fe31.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <427fbc8d0cf56b9cbdfb7f5bef31a96c4b40fe31.camel@intel.com>

On Tue, Feb 21, 2023 at 10:13:16AM -0800, Vishal Verma wrote:
> On Tue, 2023-02-21 at 09:22 -0800, Alison Schofield wrote:
> > On Fri, Feb 17, 2023 at 05:40:24PM -0700, Vishal Verma wrote:
> > > This test failed intermittently because the ndctl-list operation right
> > > after a 'modprobe cxl_test' could race the actual nmem devices getting
> > > loaded.
> > >
> > > Since CXL device probes are asynchronous, and cxl_acpi might've kicked
> > > off a cxl_bus_rescan(), a cxl_flush() (via cxl_wait_probe()) can ensure
> > > everything is loaded.
> > >
> > > Add a plain cxl-list right after the modprobe to allow for a flush/wait
> > > cycle.
> >
> > Is this the preferred method to 'settle', instead of udevadm settle?
> 
> Generally, no. Usually cxl tests would use cxl-cli commands, which now
> have the necessary waits via cxl_wait_probe(), so even a 'udevadm
> settle' shouldn't be needed.
> 
> In this case, the first thing we run is ndctl list, which waits for
> nvdimm things to 'settle', but we were racing with cxl_test coming up,
> which it (ndctl) knows nothing about.

OK - I'll stop doing the udevadm settle, since what I'm doing is pure
'cxl' and modprobe is always followed by cxl-cli commands. 

> 
> >
> > >
> > > Cc: Dave Jiang <dave.jiang@intel.com>
> > > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  test/security.sh | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/test/security.sh b/test/security.sh
> > > index 04f630e..fb04aa6 100755
> > > --- a/test/security.sh
> > > +++ b/test/security.sh
> > > @@ -225,6 +225,7 @@ if [ "$uid" -ne 0 ]; then
> > >  fi
> > >
> > >  modprobe "$KMOD_TEST"
> > > +cxl list
> > >  setup
> > >  check_prereq "keyctl"
> > >  rc=1
> > >
> > > --
> > > 2.39.1
> > >
> > >
> 
