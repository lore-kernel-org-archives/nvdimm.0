Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC651EA7ED;
	Thu, 20 Feb 2025 21:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740088303; cv=none; b=KK1yAsuTVcbrqPxTMeEiSjQpqqX17WKTWUQMMupA+XVHS25JOGXncFLKm9ZGoyS7QX09kHqtj3ZMmVhZbBuUgR1XuhNldnXuVP5lJLx46LcfBctGyrafruiBwmX6MP7IjxtDkY2dFHYx0JcMu2EUrelBd/K/SLd859Ywxe/3sro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740088303; c=relaxed/simple;
	bh=TNZ3qsbVdqL4Fe+x4ZUF0GPYQAyac6RoxiwkW8Ut+Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HA57CwyVuA4hjb0wah4YPobyCP0JLnxMsyPM7iC8oqgCusyS0fc8o1dMTYqg/6fieNfo9uiYRSmFouT3aILWUxqixMPD0DABrB3TYFpJop4aBhkLkrUECoEJvsrrOlRn3CdIaqWEhRMLhV8yrZ/Vx/508nzBc9HFSNLswIKu1aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=VmRvqU1Y; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="VmRvqU1Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=wdWJVChJiK1pkKARKzPKElyiL0rYciXwsXROkxihDGM=; b=VmRvqU1YzDEp3TDk
	IaB6OxYj38GHPTr+gwavi7Jr3hJssuKri32pz+pipXPVHlzqYvl4xVS1hylAvJikD4hi4e95m7i05
	c/K5n9b4Xy1PjkvCHn4ugSA46v9fOUalYT/70H5xmBAMl63/lFqiB3JNDv6GkA7i3pNH+xb6pHNn8
	EO6DaoQTsOXXcpTSXr4HTW0pekWgrftP1Ps3GBeOzRMh6H8lMYtjeXIkX5W0ExPVdvi46xNZmdGRW
	zpOnhV2E5LhBs73IhqKnXAsqKf+TB4lZOeO5aGgGuvc8b1OCLNTG3O/KpehUO2YuCIaHdLP2CAKEU
	xPVP4CZroH3q8gHC8w==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1tlESI-00HJKh-0W;
	Thu, 20 Feb 2025 21:51:38 +0000
Date: Thu, 20 Feb 2025 21:51:38 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Alison Schofield <alison.schofield@intel.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] nvdimm deadcoding
Message-ID: <Z7ej6lBOfRATYhER@gallifrey>
References: <20250220004538.84585-1-linux@treblig.org>
 <Z7eSmfcdNeYr1rWa@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Z7eSmfcdNeYr1rWa@aschofie-mobl2.lan>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 21:14:01 up 288 days,  8:28,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Alison Schofield (alison.schofield@intel.com) wrote:
> On Thu, Feb 20, 2025 at 12:45:36AM +0000, linux@treblig.org wrote:
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > 
> > Hi,
> >   A couple of nvdimm dead coding patches; they just
> > remove entirely unused functions.
> 
> I see you've been sending patches for dead code removal
> for several months. What tool are you using for discovery?

Hi Alison,
  Thanks for noticing.

  I'm using my own very very hacky scripts; notes below.
The problem is they generate lots of false-positives
so I've got this big output file from one run of the scripts
and I then have to go through finding the useful ones.
I start with an all-yes-config build on x86, then the
script dumps all the relocations using readelf and finds
symbols that are defined but don't have any apparent
use.
(Actually not quite all-yes-config, but close)

Then for each of those symbols I grep the whole tree
for the symbol and get myself a huge debug file.
That means that for each symbol I'm hopefully left where
it's defined and declared, and if there are actually any
uses that weren't built in my world they show up.

Then I gently work through these, look them up with git log -G
to find when they were added/stopped being used.

On one side there are false positives (stuff only in other
builds, so that's why I grep for the symbol name, also
symbols that are defined but only used locally in a .o
file)
There are lots of false negatives as well.
But then I have to second guess from the git output
  a) If it was recently added don't bother, someone is
probably about to use it.
  b) If it's actually a bug and it *should* be called.
  c) If it's a trivial one liner I don't bother
  d) If it looks like it's really a wrapper of every
firmware call for that device I leave it.
  e) Skip anything __init etc marked, or look magic
(bpf etc)

It's tricky because they're all over, so you fall
into the preferences of each maitainers oddities of
what they care about.

My debug file is alphabetically searched; I'm just near
the end of the n's - a while to go!

I'm hoping once I get to the end, then it'll be a bit
cleaner and I can tidy the scripts up and watch for
new entries in each release.

For reference for the nvdimm symbols my output file looks
like:
---- nd_attach_ndns[^A-Z_a-z] ----
drivers/nvdimm/claim.c:44:bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
drivers/nvdimm/claim.c:59:bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
drivers/nvdimm/claim.c:65:  claimed = __nd_attach_ndns(dev, attach, _ndns);
drivers/nvdimm/claim.c:216: if (!__nd_attach_ndns(dev, ndns, _ndns)) { 
drivers/nvdimm/nd-core.h:139:bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
drivers/nvdimm/nd-core.h:141:bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
drivers/nvdimm/btt_devs.c:211:  if (ndns && !__nd_attach_ndns(&nd_btt->dev, ndns, &nd_btt->ndns)) {
drivers/nvdimm/pfn_devs.c:311:  if (ndns && !__nd_attach_ndns(&nd_pfn->dev, ndns, &nd_pfn->ndns)) {
---- nd_region_conflict[^A-Z_a-z] ----
drivers/nvdimm/nd-core.h:130:int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
drivers/nvdimm/region_devs.c:1260:int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,


Scripts
  (Which I've not run for a few months, I'm still working through
the first main run)

I start with:
  find . -name \*.o -exec ~/sym/dosyms {} \;
of which dosyms is:
--------
  echo $1
  DIR=$(dirname $1)
  NEWN=$DIR/$(basename -s .o $1).x

  readelf -W -s -r $1 | awk -f ~/sym/relocs.awk |sort|uniq > $NEWN
--------
so that gets me a load of .x files, which I run through
  awk -f ~/sym/collate.awk $(find . -name \*.x) > col
of which collate.awk is:
--------
  { if (($1=="u") || ($1=="U")) {
      use[$2]=use[$2] "," FILENAME
      usecount[$2]++
    } else {
      def[$2]=def[$2] ",:" $1 ":" FILENAME
      defcount[$2]++
    }
  }
  END {
    for (s in def) {
      if (usecount[s] == 0) {
        printf("%s:%d: %s from %s\n", s, usecount[s], use[s], def[s]) 
      }
    }
  }
--------
Then the following magic:
  cut -d' ' -f1 col | sed -e 's/:.*/[^A-Z_a-z]/' | while read SYM; do echo $SYM; ag -s --ignore '*.x' --ignore col --ignore col2 "$SYM" < /dev/null; done > search.out

which gives the output shown above.
(ag is a fast parallel grep, 'the-silver-searcher' )

> Thanks,
> Alison

Have fun,

Dave
> 
> > 
> > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> > 
> > 
> > Dr. David Alan Gilbert (2):
> >   libnvdimm: Remove unused nd_region_conflict
> >   libnvdimm: Remove unused nd_attach_ndns
> > 
> >  drivers/nvdimm/claim.c       | 11 ----------
> >  drivers/nvdimm/nd-core.h     |  4 ----
> >  drivers/nvdimm/region_devs.c | 41 ------------------------------------
> >  3 files changed, 56 deletions(-)
> > 
> > -- 
> > 2.48.1
> > 
> > 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
