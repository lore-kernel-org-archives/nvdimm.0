Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B461B41B343
	for <nvdimm@lists.linux.dev>; Wed,  4 Feb 2026 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217984; cv=none; b=DtafZSRrHpyjsePlQ60BY/WJc/jUuG0IhzVfw51M+mEBs4aSzNk2giLEQQm43rl2bXecHOqchV7s4qQDmzIOp8V47Ei2doYflPsQH/FX4BI3hT8w38UvIadsFgRL+he9ecAZOys5WJuFP479Atu08yV59HpRKXKv06qCppOf3bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217984; c=relaxed/simple;
	bh=Kdt5f0wYg7/+/qeYolnntmKx3iJzBXpQKYqyXhwXNS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gtf4SvIGW7s9zQevDNF6IDqxL0l058UcIxQ5EAjS86Xc6D/m8lzOZGHW9rS3nnTJeRHiUHuIEHMtWZpgX+q7eWiFWdpxHxMLXO1V+cvNODwiKgPHl64YZj4TjRiOOyr0/lohD+FDanuW0Po6/BUSt8vn6TxHw6eSrz1U832NJ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Q+OLB8sq; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Q+OLB8sq"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-505a1789a27so37182461cf.3
        for <nvdimm@lists.linux.dev>; Wed, 04 Feb 2026 07:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770217983; x=1770822783; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zz4SDCUxIO2P6bVf59xDA2MnAUaQnUrmgZ7GFrx6FBI=;
        b=Q+OLB8sqb+ImgRX7L2RfURx/uuX+gIx6/i3XLOByA3kXx3w0EOmpkJCRwuX8HvPnpE
         X5G5rGa7q2gzl/d04/W1aJ64SdqwHz2yn76JgS1IvsZ/x3ifycTQ7emJGYdZj+ANFaCs
         U5/F9rtkgmmLFMgJmGaa2oqYskAl4eJE6pXP150blTRX32J3PUQiyElCHOIhDWyRlYC7
         krfF5M+eyBDHjPbx11ZKKN0kkNSVH8Y385gP0Us6IcgH5Du+maCZaAf2FPlpNyF+RwCn
         kdA9Xv+L7tmATEyi+qWj1QLfo9m7R3K5V7DuoNrX6maAcXhk/FvvSBHh/iVDfAj5zafs
         z40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770217983; x=1770822783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zz4SDCUxIO2P6bVf59xDA2MnAUaQnUrmgZ7GFrx6FBI=;
        b=DMgYPoXqgU+Z+NcCkELJEkkdcj1uZsgSRcXG43dKreEHgxVsldUMjXTeyOsX06oxDS
         /Ojj7P8yxA/Los1nQjM5j1mXLVLwPHOV3ordenpEcxMVWeyXdLVXsKvOj13jfEc8HCjd
         lQBGafwn0Bs6Zy4SsUY1bXjWkJ52gyyBZ2MPOIkgzvvGbxfzC5boozK1SvLVlOeP5AYT
         QB4qUkvMN2WiNyOr2Ufz74drohIijsW67gL43NlMxsxbVBkhvaBRHBiWm13tDOu/qUit
         4ibZvStseE1AbYG0ahZQhucMCn0GwDQpwLrBrpTJqrquem56+w+YhKC/oFRqXVBs4AeN
         sqfA==
X-Forwarded-Encrypted: i=1; AJvYcCXF9wFX0pta3h2rO/65gkVaKU1Yzi+0AxrsguQFKWzSxd1vokqcobRjPpMECkbg+k1sQp1Mndc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjjAecspxXjvqSIiguQfOVcZ4hyCm+0xlKOTXhPO5WqfK79uuE
	S6/Us1QXCPAxaQCN3LRhQ5SUFnGyR0hHVrIzxyG1/v1R4DGl2NGWFvY5/hbsgb3jQdc=
X-Gm-Gg: AZuq6aJL+s55kWKOawSh3kWnSd3xuJkUhMdgwvQKTE62q8yMimmxCspk+kvQw7+YI4K
	gmL4Xek/L3Uk5dVEq+qy/zRCzu9xKkLSKMiguL9CMTTDyXV9i5s4z+nJAHxN8zQbzy7MBQMfq7K
	hAxcHok9gCfhVxHuPVFQGm01czhbF019PKyMzt9H2l1ttVjIMHHNSfvQJhdkRbr7dii/YrP2H2z
	wKsw4vWxSrvA3ohQTEVneYTyq8tAaSi84PC3MGWkVSl9T+721cCVJXfIEyMIAN50IgELBeys2pU
	NgQjOMHt1QCpXMNr8TV8i/TE2t9OEkp3TVg7o5FQosllSEIIOyybbAh2dGf69Hqot89HadEQ8Na
	86qvsFJkfP7wcUt8PLlz41vSvcfVQqPxpL/njSh7o9kA58sBWXJx17WL9SmW0gfIGYYguDQF4KT
	xv2UbpeR4XK5OrhtrKxLvz2/xu3dYocaf/T6Fsq5u/sQ9RMA+wqnRcDfWGfNot6PpRVW3wNw==
X-Received: by 2002:a05:622a:1646:b0:4ee:1903:367b with SMTP id d75a77b69052e-5061c0c7963mr41878211cf.5.1770217982318;
        Wed, 04 Feb 2026 07:13:02 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5061c1e7f63sm21650531cf.18.2026.02.04.07.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:13:01 -0800 (PST)
Date: Wed, 4 Feb 2026 10:12:58 -0500
From: Gregory Price <gourry@gourry.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <aYNh-m8BEiOHKr9h@gourry-fedora-PF4VCD3F>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
 <698270e76775_44a22100c4@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698270e76775_44a22100c4@iweiny-mobl.notmuch>

On Tue, Feb 03, 2026 at 04:04:23PM -0600, Ira Weiny wrote:
> Gregory Price wrote:

... snipping this to the top ...
> Again I don't like the idea of needing new drivers for new policies.  That
> goes against how things should work in the kernel.

If you define "How should virtio consume an extent" and "How should
FAMFS consume an extent" as "Policy" I can see your argument, and we
should address this.

I view "All things shall route through DAX" as "A policy" that
dictates cxl-driven changes to dax - including new dax drivers
(see: famfs new dax mechanism).

So we're already there.  Might as well reduce the complexity (as
explained below) and cut out dax where it makes sense rather than
force everyone to eat DAX (for potentially negative value).

---

> > has been a concern, in favor of a per-region-driver policy on how to
> > manage hot-add/remove events.
> 
> I think a concern would be that each region driver is implementing a
> 'policy' which requires new drivers for new policies.
> 

This is fair, we don't want infinite drivers - and many use cases
(we imagine) will end up using DAX - I'm not arguing to get rid of the
dax driver.

There are at least 3 or 4 use-cases i've seen so far

- dax (dev and fs): can share a driver w/ DAXDRV_ selection

- sysram : preferably doing direct hotplug - not via dax
           private-ram may re-use this cleanly with some config bits

- virtio : may not even want to expose objects to userland
           may prefer to simply directly interact with a VMM
	   dax may present a security issue if reconfig'd to device

- type-2 : may have wildly different patterns and preferences
           may also end up somewhat generalized

I think trying to pump all of these through dax and into userland by
default is a mistake - if only because it drives more complexity.

We should get form from function.

Example: for sysram - dax_kmem is just glue, the hotplug logic should
         live in cxl and operate directly on extents.  It's simpler and
	 doesn't add a bunch of needless dependencies.

Consider a hot-unplug request

Current setup
----
FM -> Host
   1) Unplug Extent A
Host
   2) cxl: hotunplug(dax_map[A])
   3) dax: Does this cover the entire dax? (no->reject, yes->unplug())
      - might fail due to dax-reasons
      - might fail due to normal hot-unplug reasons
   4) unbind dax
   5) return extent

Dropping Dax in favor of sysram doing direct hotplug
----
FM -> Host
   1) Unplug Extent A 
Host
   2) hotunplug(extents_map[A])
      - might fail because of normal hot-unplug reasons
   3) return extent

It's just simpler and gives you the option of complete sparseness
(untagged extents) or tracking related extents (tagged extents).

This pattern may not carry over the same with dax or virtio uses.

> I did not like the 'implicit' nature of the association of dax device with
> extent.  But it maintained backwards compatibility with non-sparse
> regions...
> 
> My vision for tags was that eventually dax device creation could have a
> tag specified prior and would only allocate from extents with that tag.
>

yeah i think it's pretty clear the dax case wants a daxN.M/uuid of some
kind (we can argue whether it needs to be exposed to userland - but
having some conversations about FAMFS, this sounds userful.

> I'm not following this.  If set(A) arrives can another set(A) arrive
> later?
> 
> How long does the kernel wait for all the 'A's to arrive?  Or must they be
> in a ...  'more bit set' set of extents.
> 

Set(A) = extents that arrive together with the more bit set

So lets say you get two sets that arrive with the same tag (A)
Set(A) + Set(A)'

Set(A)' would get rejected because Set(A) has already arrived.
Otherwise, accepting Set(A)' implies sparseness of Set(A).

Having a tag map to a region is pointless - the HPA maps extent to
region.  So there's no other use for a tag in the sysram case.

On the flip side - assuming you want to try to allow Set(A)+Set(A)'

How userland is expected to know when all extents have arrived if
hotplug cannot occur until all the extents have arrived, and the only
place to put those extents is DAX?  Seems needlessly complex.

> Regardless IMO if user space was monitoring the extents with tag A they
> can decide if and when all those extents have arrived and can build on top
> of that.
> 

This assumes userland has something to build on top of, and moreover
that this something will be DAX.

- I agree for a filesystem-consumption pattern.
- I disagree for hotplug - dax is pointless glue.
- I don't know if DAX is right-fit for other use cases. (it might just
  want to pass the raw IORESOURCE region to the VMM, for example).

> Are we expecting to have tags and non-taged extents on the same DCD
> region?
> 
> I'm ok not supporting that.  But just to be clear about what you are
> suggesting.
> 

Probably not.  And in fact I think that should be one configuration bit
(either you support tags or you don't - reject the other state).

But I can imagine a driver wanting to support either (exclusive-or)

> Would the cxl_sysram region driver be attached to the DCD partition?  Then
> it would have some DCD functionality built in...  I guess make a common
> extent processing lib for the 2 drivers?
> 

Same driver - allow it to bind PARTMODE_RAM or PARTMODE_DC.

A RAM region hotplugs exactly once: at bind/unbind
A DC region hotplugs at runtime.

Same code, DC just adds the log monitoring stuff.

> I feel like that is a lot of policy being built into the kernel.  Where
> having the DCD region driver simply tell user space 'Hey there is a new
> extent here' and then having user space online that as sysram makes the
> policy decision in user space.
> 
> Segwaying into the N_PRIVATE work.  Couldn't we assign that memory to a
> NUMA node with N_PRIVATE only memory via userspace...  Then it is onlined
> in a way that any app which is allocating from that node would get that
> memory.  And keep it out of kernel space?
> 
> But keep all that policy in user space when an extent appears.  Not baked
> into a particular driver.
> 

I would need to think this over a bit more, I'm not quite seeing how
what you are suggesting would work.

N_MEMORY_PRIVATE implies there is some special feature of the device
that should be taken into account when managing the memory - but that
you want to re-use (some of) the existing mm/ infrastructure for basic
operations (page_alloc, reclaim, migration, etc).

There's an argument that some such nodes shouldn't even be visible to
userspace (of what use is knowing a node is there if mempolicy commands
are rejected or ignored if you try to bind to it?)

But also, setting N_MEMORY_PRIVATE vs N_MEMORY would explicitly be an
mm/memory_hotplug.c operation - so there's a pretty long path from
userland to "Setting N_MEMORY_PRIVATE" that goes through the drivers.

You can't set N_MEMORY_PRIVATE before going online (has to be done
during the hotplug process, otherwise you get nasty race conditions).

> > But I think this resolves a lot of the disparate disagreements on "what
> > to do with tags" and how to manage sparseness - just split the policy
> > into each individual use-case's respective driver.
> 
> I think what I'm worried about is where that policy resides.
>
> I think it is best to have a DCD region driver which simply exposes
> extents and allows user space to control how those extents are used.  I
> think some of what you have above works like that but I want to be careful
> baking in policy.
> 

I guess summarizing the sysram case: The policy seems simple enough to
not warrant over-complicated the infrastructure for the sake of making
dax "The One Interface To Rule Them All".

All userland wants to do for sysram is hot(un)plug.  Why bother with
dax at all?

~Gregory
