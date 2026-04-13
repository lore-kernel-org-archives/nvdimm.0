Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2144A31D371
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 19:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109098; cv=none; b=GK+AVmUWkFkn3zBGBk9GgPZmrrKHLlarLwue1vXIWlSgPUj5z6ifNT3AXWWM0JUQ49LNf3VywBCA8HHJGPzCoptm3b/x/ADRBrMys/S7IHme56oE0U4SKgjvd8LZeJj4YHgP7XB64W13kswJ3qLUM6KZT6CuewYWB5jRvZQwgys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109098; c=relaxed/simple;
	bh=iq+k1kdjsFO//4jKVGXmpkWsGljQ+hWQez+mk2k+r5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cA21HDO262IUcVd9xA12rzgVGz+AWql4i43Tj7QFjySShy2i8XN7eksnYuAYzAuBzc5t/9C9VpdZ7l6H4HzvqL+HqOiErTpDyfAUmgiabCYAjzxASTyUG/0m+wKKsQ/4l7NK4Wk/HaP+IYX1GdXvnUFeh9+M+T3rEt4Yk7qLZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Spjoz/vu; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Spjoz/vu"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d6144877aso50987471cf.3
        for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 12:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776109096; x=1776713896; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+Cg30G7JazeOMCJRrNEUInL5xwrDgCPHzG/fcerzOo=;
        b=Spjoz/vuMPOA6fEm12I3GSKdM9ZeZNWG74UyXJMGKxv2yJnnQXdr+zwCSlent2uTFg
         2UZvtZ8+INNj1YOPQpayKKgNaMASmSTQ2r0KCRyuYueukYvSEZ0DojEUVwh6WzO0DgUq
         RZZAzhHtcPfxgYy6VtQAPxpfpDLjwnF+SEVcmUV5kS9CBB6kLI0nbeTS8cnbBlg/fLfc
         P2x5fwZEiStHOmBif9/Dc6zotpAVoV38ctGSIWdAHzvWQLZOntr4sWmKwLoDZqJJiHOj
         TIdW00dlCiGXIQasvY3QhrnjpmIbUR2CYyFlGea4lJiJE84L0BJvMVqPD5KyH7ICv1a4
         hlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109096; x=1776713896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+Cg30G7JazeOMCJRrNEUInL5xwrDgCPHzG/fcerzOo=;
        b=kdXRJA8Bn3UEbyHF+TkUV6qLpzGhE6Kjwt08YyDho5hXFD1+gI96izXOSFEe5fkU6h
         mXoWN+jxt0Q5RYKYhjKFRzKr3nwOfxZLsDTeW4F3vyi3+mCcaGRo/JoUwnxBSteZohLi
         cfNBJCeQ2nNTB/2MSgOV/AHn5LIlUZVCo5PPJI3cF8tskD6i8MLqLl2eN58mOfTNkR/J
         UPevCVBt5tvx2QpXOYINAZQ0/gLzQwijhyMJI1gtXl6zC+V51Y5t4gxZvFdG5A9mEm4h
         Y7PS24iWc4CKcSkhbEozyJV4gu1Yh0mEcVbHMmLVOx6Wmr4s51gtBBENO5IIg5aoAGOE
         7D7g==
X-Forwarded-Encrypted: i=1; AFNElJ/XQhwRRnUiNBkPsuim+f+FrrthSyb3bCMyNFafmtz+JsIoIPbX97y1xJFhaNbHau/2q8NpFro=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEJ0X8tJ/WL5y2IOjdVF4KT64CW2t9xmqTPajeEggcOcLr9Vvn
	ZNNJi9edUPmS4UOxy0QHjRMUNMegDxFP5ClWUaSkxA9x3gdboaq0vH/B4IeEPx9H/ns=
X-Gm-Gg: AeBDievyV5yIeuTqDgfjC6hdMoH7CQI8FFptVnB2NW3AQdleXmnJxjp89c8WUo7lY08
	XJknhHimxmnXvyUe3bf4+uaT460gWozMfLBYpwwVxAT0iwrK2AgueTFO2TM3CZHeIvor6D0MBb6
	8L+Zb6gSfuQQi29t25h6VRInHwliYKUUsYI8xe2Ls8d6N0pPhxeSIPIawbQW0FX7i9wwWPd8y2n
	hN1lTGqkhoEAyO3uGEYa/27r9XFpm6fWidHG8jtHM8mZPKKPpfAXXfdsr1rtcseWHGzoiLjspgf
	DuWie8lBpeBFyj9zQygpFQx5wmCJndbrg/LTIbrWYnvuX6EFY7wai9i6XKXbLAuTjvOPCHDx56U
	7UReDU2V7kXLt6xP8rn1IcluCqcZduFvfixupZElgIVN6PYwDllLNxGOuJvGI4DZhTIjpPi1et+
	VTwE+7hwkQd6jWEj+ggE9F6PPgt510e5UA3ztd2A9bccWZe/zL7b7MSxP8Xuj62s1aVDYBArlI9
	n6/tsIVl5kwvROlWijF6K1ju6+RRw/iLA==
X-Received: by 2002:a05:622a:82:b0:50d:8210:eea6 with SMTP id d75a77b69052e-50dd5a97fddmr224412971cf.1.1776109095971;
        Mon, 13 Apr 2026 12:38:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50dd564c160sm95841161cf.30.2026.04.13.12.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:38:15 -0700 (PDT)
Date: Mon, 13 Apr 2026 15:38:13 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, osalvador@suse.de,
	dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ad1GJRyAfIAhj1iz@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
 <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
 <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>

On Mon, Apr 13, 2026 at 05:47:01PM +0200, David Hildenbrand (Arm) wrote:
> 
> So, really only user space can try offlining the memory after requested
> onlining succeeded.
> 
> I don't think any udev rules do that? The usually only request to
> online, which should be fine.
> 

In the offline case the block will cease to exist after offlin/remove
returns, so what should happen is the race on offline just fails and
the stale object cleans itself up on the way out after failure.

Userland temporarily sees a stale memory block but can't do anything
with it because sync'd on hotplug lock.

> So if a user does that manually, good for him. We just have to make sure
> that stuff keeps working as expected.
> 

Yeah the only catch is if a user does something dumb like

    cat block/state -> online_movable
    echo offline > block/state
    echo online > block/state

But like... don't do that :]

Udev won't ever offline-online-race like this, so it's not a real issue.

> Or am I missing a case?
> 

So yeah, I'm fairly confident this just works.

> 
> I'll note that offline_and_remove_memory() can take a long time/forever
> to succeed. User space can abort it by sending a critical signal.
> 
> For example, if you do
> 
> $ echo "unplugged" > magic_device_file
> 
> And it hangs, user space can kill the "echo" command, sending a fatal
> signal and making offline_and_remove_memory() fail.
> 
> The question is, if you want to do your best to revert the other offline
> operations and try re-adding/onlining what you already offlined.
> 
> offline_and_remove_memory() handles that much nicer internally, as it
> tries to revert offlining, and only removes once everything was offlined.
> 
> I think I raised it previously, but you could add a
> offline_and_remove_memory_ranges() that consumes multiple ranges, and
> would do this for you under a single lock_device_hotplug().
> 

I don't think this is a very large lift, just a slightly larger hotplug
locking scope.  But then - the per-range thing in this set should just
work, so let me know if it's worth the extra churn.

~Gregory
