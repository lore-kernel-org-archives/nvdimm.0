Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858C8229B38
	for <nvdimm@lists.linux.dev>; Mon,  9 Mar 2026 06:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773037643; cv=pass; b=K2fvnfOGkEihKWGrPrVSlxBLZLKzbECI8Kmqjg+dJJthkeZp1umlfOgHukKaJgYhrwfhqH4LkGIqHGotao+tIp08Df9wcH8msYTPklLlmyV/4D/b7jy7wT1ztHLSAWxKctextU5iNXxC1idBbwJI1oyIEO7GpnPcrP81ACOmMXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773037643; c=relaxed/simple;
	bh=tWJ/fX3Ckxq4WEzhukQr0K7T+NWwaaBTCqm8O0qx06M=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a2be9BPEWGSlqPSu58k3JXs+2G8By8V0w2ebcZBhY1JUWcGMTsgPpGK+Mpn7UFve7cXHN7xOKHeg1/mbPpkK+Y/Rr2we1AViQ0Xz7JhXuw9uF4uenERq8s63Q2S/up65RxW1VbgZMdefT6SV0mPgWT380prABE7BdholK5+sMl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYNxQHSM; arc=pass smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYNxQHSM"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-5ffa0b23a60so1895361137.0
        for <nvdimm@lists.linux.dev>; Sun, 08 Mar 2026 23:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773037639; cv=none;
        d=google.com; s=arc-20240605;
        b=DcPvZELtWYmybMWDvAFA0GNfvQd3ky55VNRgB3PlyR9K721V7FjUPcusMPTfgvGIkl
         VuG0EXWjjuPejA1VxSzqB4QEp9Mc0RmpaTWZiTfWSR//pd/7ajKAI/na/ryTW7XMYjiF
         iWY9OmNWAXHSz70CsfN8ZXVuyOj3xDbyVlpIZXGHCToKlHwiEZuZEvwj+hpDbGMe5XEy
         PvuHVYnH/vbvAZtcoOuMqnKwDZ9zYoVH5MxB4iFhA/qhPYJ3f8nvFi6oxk3ObM9xiDVG
         jQHWJ/V4Y2r0HDKEifBR/PV3qOH93glt71zGzYht/1Mg0ntjZ5DE6grbzbnobU8y+9yM
         YJNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=uthJSqpDGuue4aeWUw9ODMGHbGatL8hg/W+VDtshmKs=;
        fh=/XQMeSZZ/z07CrViC9OemH/K/1A2L5hZ8VSN2kp3hLA=;
        b=dxzgS3O/CvIi/sfGIs47Qn7bx4e9JLGlpSdNFzZKatOXZBCKOlWUE0aYaHYbGAdjiK
         Nv41juPQuFZB4dgNXKZMb3exwIYfPVk3oYOGneHHHGOHRXJD/RfND5mQszS2iHhV14Er
         nq931D5OHnSQRKgaUnTuU8jp1KL2A4HurLwM7ieWXh3MC7NXPe8yIJf352ubkBNTUpU6
         RqUCpskuNg3y7NMfwFktyu5jbS7QI87dcc+SiZ7Xdr/KYf2Nrnzs63PkrX77EMxgC3V5
         A6Vbh5FI9tGCz/Gmx0a+QBhp9Wo2Wn7mdUfyORGYymod1kDdxLKbrdcpNSwBMDSvC/K2
         N/JA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773037639; x=1773642439; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uthJSqpDGuue4aeWUw9ODMGHbGatL8hg/W+VDtshmKs=;
        b=LYNxQHSMtDxRc6GfEZoWbEZiPSEfe8yqpaDxhQoVfGcp9Nqa+/AXwIcVLk0x5DdZxq
         kNoknNBPzS5uEt+8EcxqsfDsKCUcvwz1Z9Ax3fmcORuC8uExkbH8NTRsNVGlhMQ8I/SO
         rGVgRjfAk2iAAdqwrfgVECrExcUCH+eM+V9IELal2nrYpkngtGqyCCKy9mwiZBz+f1kX
         XuuaSmXDLBPGqjaVLH9VJnPAzpd7/iJ1ULwTVxYEImii10JoVg3bQP9OJ/aO9YJxsDU/
         sXDhPbWFMyDIbf7wc2O0+rtqM7uuyRJ7iRo/KdWNqRJkwR8UYBaJSQNlkhfEBsohb3Ci
         sjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773037639; x=1773642439;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uthJSqpDGuue4aeWUw9ODMGHbGatL8hg/W+VDtshmKs=;
        b=tS5glL5up7HX94LWaHpDlF6h4ymK4GpQ0IOEfw4igar8vNvgGWg+NEW38CGCLPPAZs
         7r/5QKL6lqNWKzcrSAOlJuYi2csy7Xy1gJXS+bZv/F5hDNTzxOWxQXSRgTDxpQS7nt8t
         tOS8YrrKgKtlhGtGWz5Onsih3qs/0tJXehWyxd+lk0103+qMSs56CiBsrw0vGBVJbaqa
         u/hWb2OvRex84PR9w6Qk0lLPSIN9r8erOK3dpkTZ8LMt6x8mm1/k4y21wC7ZicVNSRsU
         SfRiB4pwafMIZM6JSMzIUxPxzi2Ypnnb4idpg49ycp9u/wbF48MKoNfcRlhOWbCKW3JD
         Sr4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU8GhgmV/YwYTXUqB8EE5XQ34XWPDzQ24CRWHU3Xi+me+JyLsDK5JOCGvFdv/VPXfyd4ULiU14=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr2ZFrq+xAXSY+S51s++fMBAzd6zAFfEnWrCQfiw3xLciWGLED
	8CtP6KMxjxVDuQT7olmDLPLMPetbux9eQbLF+KDh4wFoMhqgLbhFiBkvH3WxGob3N0BYRITkPp1
	4K6DbSGr1qUnFdfMNK9OfW1B5UtE/eQKAqLly2aNG
X-Gm-Gg: ATEYQzxpUFhwPwmw1daLTP/3Oc4appLSdPV7+bzlPAn7dlZwavSNQawaHs4QMvGF+0L
	R9AaZ/RZLUwFwaEcLKQ15/Lp1GQlr1njLkehJmZNAmnS6YK/l8K047bTsB0A5XZiupgszDY7je+
	ya9rmri1V+indYUwAJsQ5Mp0rfomew1rlTArHyLJQ6I7W0vA3mpasF5gSSs+G5bZLDB4u94+864
	gNl7US/2UYVEjOLgxDVBlypiUYqo9XGSqJFPeujYZdP+vqjoPjzg4rAfN6Y61XqfZJE2TyFUUW5
	YPa6rInGH0xzapfh0MOEYpPdWPQYOky88fCy/2SIJ2BpKxoRI9wKgp3GRq8fWt9djudqew==
X-Received: by 2002:a05:6102:c01:b0:5db:f920:fa9a with SMTP id
 ada2fe7eead31-5ffe63cdb3fmr2925679137.41.1773037638925; Sun, 08 Mar 2026
 23:27:18 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 8 Mar 2026 23:27:18 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 8 Mar 2026 23:27:18 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aaWlxFh-bqUYXgUo@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223110.92320-1-john@jagalactic.com> <0100019bd33bf5cc-3ab17b9e-cd67-4f0b-885e-55658a1207f0-000000@email.amazonses.com>
 <CAEvNRgHmfpx0BXPzt81DenKbyvQ1QwM5rZeJWMnKUO8fB8MeqA@mail.gmail.com> <aaWlxFh-bqUYXgUo@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sun, 8 Mar 2026 23:27:18 -0700
X-Gm-Features: AaiRm52XcCdEx1v_REqqEWCzJAbxKWYQSWfQ7emIhDTUFVwrkCx8Utez8oZPcxo
Message-ID: <CAEvNRgEzb6Ux+iVFT=F6jc_R8V=LTYCigHp+yaHFkdrX82-yvQ@mail.gmail.com>
Subject: Re: [PATCH V7 02/19] dax: Factor out dax_folio_reset_order() helper
To: John Groves <John@groves.net>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	John Groves <jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

John Groves <John@groves.net> writes:

>
> [...snip...]
>
>>
>> I'm implementing something similar for guest_memfd and was going to
>> reuse __split_folio_to_order(). Would you consider using the
>> __split_folio_to_order() function?
>>
>> I see that dax_folio_reset_order() needs to set f->share to 0 though,
>> which is a union with index, and __split_folio_to_order() sets non-0
>> indices.
>>
>> Also, __split_folio_to_order() doesn't handle f->pgmap (or f->lru).
>>
>> Could these two steps be added to a separate loop after
>> __split_folio_to_order()?
>>
>> Does dax_folio_reset_order() need to handle any of the folio flags that
>> __split_folio_to_order() handles?
>
> Sorry to reply slowly; this took some thought.
>

No worries, thanks for your consideration!

> I'm nervous about sharing folio initialization code between the page cache
> and dax. Might this be something we could unify after the fact - if it
> passes muster?
>
> Unifying paths like this could be regression-prone (page cache changes
> breaking dax or vice versa) unless it's really well conceived...
>

guest_memfd's (future) usage of __split_folio_to_order() is probably
closer in spirit to the original usage of __split_folio_to_order() that
dax's, feel free go ahead :)

For guest_memfd, I do want to use __split_folio_to_order() since I do
want to make sure that any updates to page flags are taken into account
for guest_memfd as well.

>>
>> >  static inline unsigned long dax_folio_put(struct folio *folio)
>> >  {
>> >  	unsigned long ref;
>> > @@ -391,28 +430,13 @@ static inline unsigned long dax_folio_put(struct folio *folio)
>> >  	if (ref)
>> >  		return ref;
>> >
>> > -	folio->mapping = NULL;
>> > -	order = folio_order(folio);
>> > -	if (!order)
>> > -		return 0;
>> > -	folio_reset_order(folio);
>> > +	order = dax_folio_reset_order(folio);
>> >
>> > +	/* Debug check: verify refcounts are zero for all sub-folios */
>> >  	for (i = 0; i < (1UL << order); i++) {
>> > -		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
>> >  		struct page *page = folio_page(folio, i);
>> > -		struct folio *new_folio = (struct folio *)page;
>> >
>> > -		ClearPageHead(page);
>> > -		clear_compound_head(page);
>> > -
>> > -		new_folio->mapping = NULL;
>> > -		/*
>> > -		 * Reset pgmap which was over-written by
>> > -		 * prep_compound_page().
>> > -		 */
>>
>> Actually, where's the call to prep_compound_page()? Was that in
>> dax_folio_init()? Is this comment still valid and does pgmap have to be
>> reset?
>
> Yep, in dax_folio_init()...
>

On another look, prep_compound_tail() in prep_compound_page() is the
one that overwrites folio->pgmap, by writing to page->compound_head,
which aliases with pgmap.

No issues here. I was just comparing the before/after of this
refactoring and saw that the comment was dropped, which led me to look
more at this part.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

>
> Thanks,
> John
>
> [snip]
