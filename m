Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687603;
	b=ZCBiCKz4TmghYnlQS552kUFPtLsKS65cdG/8VdXAl8/ii+J+ihzfIZgHghZ6sQ3jkUrB
	 gouF5J1e4K6mqj21eQwLjvly2ylxP5hjk5QWZnV4Ha75K+c53ocZDqfljp5WUtwDzgMc9
	 yL3tk+Zt5a0PQaMjwxwL42zjyLRo9qbe2EtDxYODXzgStE+oQj5w+s4AHoaafE5cbo4vX
	 q/0d9kOZXaFVZr+UXcDAVpxcT/KcPbpscd+DZO/Ip+qAckrbvFtEEl6/coeiIf2v5OoRN
	 +yJuZJoYC0VuPOMzXD3Sxt0mzqnrxGbVJLrRbvUzXnZ8asUPSs/vJ8k1imvCFlHSRpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687603;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=yBrOxbFSFCvT+f6YwccRu0+NATw9eg/EBC16z8r25jk=;
	b=3HaoNhjEl2f2yAhXWMmkFtujjkhf0F4X1yzXuFKc/MmMagTURMHZ92hiIpReVKIwbvrI
	 CcyvXuGsqjoNcGJakWCJeYoLRnxA3LfZjW5LFYU7WrlRyDMHLy7sfAWzw4IA5JAxiSCoO
	 9w2BPz3ojHtGZbpRTtYPXxOlRDZuC5Us4/KAozKebtMHqKd2R3E9ObSR16i/7M5lGvWRN
	 8Y+u/Svh9juy54K075BymY9WAf97VG3ytVb5Xy098kcymYUKJF49T74zmmn9l9gPc/L7p
	 TM7pdeOMwQrE/xS7Llm9Ryr5STJ19Qzy+9//KRRaF98br6uhbfyY1YypK9WfXMwO5mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WRjjjdmv;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2EF60A2601
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 16:46:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB2EF60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WRjjjdmv
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-535179e995bso22221861cf.0
        for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 09:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792687602; x=1793292402; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yBrOxbFSFCvT+f6YwccRu0+NATw9eg/EBC16z8r25jk=;
        b=WRjjjdmvcSkli72c5snH/L5UTpMB1tSsEJ7j6N0+acd/4PDLzmcNnmW7kPQCfKP83O
         5NUaxtuvHZEmF8GYmukud6t9Ywn/tDjA47l1LJ8nz8D0aGmi4EwHxwQRqiQ+vTzdtu+h
         URXAjBZ5/h9B9Fc/XwVQugacomtpAZOgwR47RobU+fTFW450h249v5EjA2r8TqNlLe+O
         F5C7P4FrlEEpJtuto5yj3ltl4ixc+0BOrTIj+Bf8/ZkFOXbEK1jUn97eeVL3ucZIetzw
         irv+aOQvJds1qHTFqtyb/ayW5A49dMv1wPtNQpbzbmbEWajwED9khzlb3pNO/ME/4ye8
         dkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687602; x=1793292402;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yBrOxbFSFCvT+f6YwccRu0+NATw9eg/EBC16z8r25jk=;
        b=GQ0wFA7am0+USRodzAa8H3qJWjKc9Lveq+FhCgV30rBn/WoOWspwmbWnom0p+Vx+OD
         IZ/ql4ZvKBO1kpxwQDGRBZGdbIz00lkAXAxD1czTpkWWcKBU8BFcfAnuB76ut1RBbtZw
         oUj5o0zVW13MaXKPw5tRdCxA08swyRmevw+NNQd8w9oMOMjp1N6LKvmF5HdUwazQYBKX
         p+snBL9RPJx1IsMxhUZAZm/mtOwpMzz8M/ywaljzHOST2QLR4NdefpRAIDv6KRLPqXRK
         1SY8drspTr02jz1Ku5PGAHFYgLxHek4anti2wy1UbArPE1Ox/Utvlm4MMhYwK2sFHroK
         lifg==
X-Forwarded-Encrypted: i=1; AKwUvBxhzVfzzvSYoYdXrajJTymKLV6xA7WW56N1n/aL3bDvF0pjSOJnXIlwFVOx+omuN/UcbNNc1vo=@lists.linux.dev
X-Gm-Message-State: AFq9FYJKY8ov7EOhuHnTKnI+57dS7DDlkQtq6CzV//NPWgTbjP4G2eHQ
	ciumPXhYFHYZwiMUQs72+gVffLt7Cs6SusPMzsB5/lgn2oTptulcWJTUK9tyfEJAtZ8aYAgsClT
	cNXXt
X-Gm-Gg: AYBFou2YR+6wHwECO7RpBNPFmCwClT68c8FZeij8bHb1W3wQWk5GPG9H5IhErU0pxiZ
	f3iCO+sOtqhBqFe/HAgqcHI6y+HQ9fas7skkI60H8tDkeVUytmAa1Nad9WVxkZ6LzQ5owcZov5r
	9RWuFXvulqnawtEnflk5yyj+b0PjisYSle/n6VJfRruugyoc0fanTH2zLVy/kSCI0j9WmTy0BSD
	6RwUAqeEnljgU1iW3UQjOIdg/XQ90/Cr2AocEGyAskNKqej3vJgAs1yJHEFUD03BBSIoeixoXKB
	ENYPOB6DSbZ173alLO3g6dlLas8TyQGcz3bIL5JvpoNUM/KIxN2tca3MKbs3xts3LQiHIJIZnjx
	NLJUDrgSbi3KdXvs0+FqQ9GT4DBA4OpFnHl+5oba1hgsllkVRKVdumqI2Kx2xG1GY5ORDCJ4mjY
	hoTn3BsXc8EbJcAtnVRDamYmyIGdetEdCArwPiOB4Fv70pEe6gc6RoPqRZ4OI8qhnNaeDxUFx0Y
	27FWEZnQ46l4qdmIBtizM2YpBFyg8uBBwebDj/EcTkL5txuxnqAN3t+e8imJJvwztEmf+0XvLAq
	9/JKWebWdwd1uiW0lr2BDSVlI/PE+JnNEfFVOpLg0KX3IcYa
X-Received: by 2002:a05:622a:e197:20b0:533:3228:74ad with SMTP id d75a77b69052e-5369b8112famr65415051cf.34.1792687601560;
        Thu, 22 Oct 2026 09:46:41 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536ab6cd0dcsm31216581cf.6.2026.10.22.09.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:46:41 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/6] daxctl: offline whole-device memory via atomic
 unplug when available
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <atly9gd-Rsf-AoqB@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-4-gourry@gourry.net>
 <atly9gd-Rsf-AoqB@aschofie-mobl2.lan>
Date: Thu, 22 Oct 2026 12:46:40 -0400
Message-Id: <179268760050.4072493.10054383256417425305.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-21 19:20 -0700, Alison Schofield wrote:
> On Fri, Oct 16, 2026 at 05:42:45PM -0400, Gregory Price (Meta) wrote:
> > +	/*
> > +	 * Unplug atomically where supported, even if already offline, so
> > +	 * no agent can online blocks before a later unbind.
> > +	 */
> > +	state = daxctl_dev_get_kmem_state(dev);
> > +	unplug = state != DAXCTL_KMEM_UNKNOWN && state != DAXCTL_KMEM_UNPLUGGED;
> > +
> 
> Hi Greg,
> 
> I see you called this out in the cover letter, and that the kernel is
> deliberately combining offlining and removing memory to avoid the race
> before unbind.
> 
> But, this does change the behavior of the command "daxctl offline-memory".
> Previously it left memory blocks present but offline and now it removes
> them entirely.
> 
> Should offline-memory keep its existing behavior of leaving memory blocks
> offline, and use atomic unplug only when reconfiguring the device?
>

The kernel explicitly does not allow `echo offline > dax/state` because
this just creates the race we're trying to resolve.

I suppose my pushback is: why does it matter that daxctl offline-memory
changes in this way? If daxctl supports the atomic interface, it all just
works. It's a bit more work (additional hot-unplug) but if the memory is
already offline that's not that expensive.

The only scenario I could come up with is having two versions of daxctl
fight with each other (old - no awareness of dax/state, new - uses
dax/state) but is this a real concern?

> > +	if (unplug) {
> > +		rc = daxctl_dev_set_kmem_state(dev, DAXCTL_KMEM_UNPLUGGED);
> > +		if (rc < 0 && num_on == 0) {
> > +			/* already offline, unplug is best effort */
> 
> When num_on == 0, another agent could online a block between the earlier
> check and the unplug and that memory would then be removed.
> 
> I see this noted in the commit message. Is that worth documenting for
> users?
> 

Yes that's intended, and yeah should probably update the docs.

~Gregory

-- 
~Gregory

