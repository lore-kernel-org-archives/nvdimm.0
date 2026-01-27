Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C102BE7B1
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 21:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769550167; cv=none; b=A3ru5FOSwTsaRYdlZrnYc/IhBQNGp0iS6Eb8Qt/a7X2508WHK2yjiWzSW3Qex0r6/qCMAN8u8GENe7cNFJBMXk+gNr+dbMqYtQbs8/pmHH3fCgaZCirpUmp94LBnq+FjwQkKMM2Pnoh1vVXzmhEleqXuAq63Ud+If9vegG37vRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769550167; c=relaxed/simple;
	bh=wOC4ZkOYUETFCbDrcLvD0xJHaN+L2/CRl5PQ14lPOFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T8H8eAfAhO6JIO24I7wNE8o6IdCbxIrKwPkNAzzz0P3SztoOaLwEuhWYBirXkZtsIdatfgAunf8bthCj8iR78osEfhoWrWGb56Ezbhb4ldptcYqaNS6bM+gNmxi8dVMGLOe+ibYOEJ5NZz0Q960rfiRGlvG2X18QjwMTydT7x/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XkdiEbdZ; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XkdiEbdZ"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c6a7638f42so866152085a.2
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 13:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769550163; x=1770154963; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5CEx45x1VqBdZR0C8+OcuXcE46R+qBWE0zGdFKjM/s=;
        b=XkdiEbdZVxVNlTRgCnnnxn8U9o4/f7aNvJwAbMw/xvaGsp1sM6urXiHKL0bNHVDKgX
         J4vc9j3qoy9eBsBttp46HRwl8GRNw3H4txFt2BsZL4KtMyapZVFU0lUnatU6IqTqquZA
         NZvr37dNx2MumMwqc62nKeyWAcuUsGYY0Sv1YOynQpW0sN1zD/V9zwdANKNRSqGyfSYc
         ysMa/12oKyD9TQY5/Tn9XXDxHSlJ1g+kWwvVzaHGN2erLKNw4kIBh43C9Kjo31AkOERX
         WfFv1jBEi9qo9Znajl9EMrJljHyJbN/8Zq9HC5bKbK/XRH9HbyPY98r55m7UHjJqu9Nr
         e0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769550163; x=1770154963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M5CEx45x1VqBdZR0C8+OcuXcE46R+qBWE0zGdFKjM/s=;
        b=ZgKvTIFmeXVXWHfr5riECPKsfCLUiJbx7beu7sgpZRi4PuLc4Tewwz13PoSfYM5/6N
         5MnpRh3DGPhTbJczQVwnFslFV2mN6MLBbDLsSuNUBmhyHQi/AfHir3sLeLi7DJTPRF10
         SRd7fue1L12Y0VKeQH24SiRe1+LiBsXXkj0Tp4DEuPM05UxfFfg2XC6yq8g8/fwEmywc
         2DlC2Wxtk3ykqYIqV+qrDZcuek3ylaZv+0yjjYNc9BmG5FhYE4A4HgI2Dn64jaJEICMW
         txVXVLFfG6b9b4gUOJCDkz4nx7qJ1R0Nls0ZYG+3BJKgrrGFcjpRHGQ9lM7lvSTXc9Zb
         G6ig==
X-Forwarded-Encrypted: i=1; AJvYcCWgJA4W5ZoFAEjgKceGU/D/7Zcsddv+fdYBWrHg6kWBpiLya8qDAZGX98oJaK05I0VN2/3YURI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww9NP1ktFtaKKS3j6VTO2gc3gxocbVb1lZtRcn78PHKR3zKzQK
	lTFDUq5hwNJ/iArHfhBDaEWM1Y4Mr/CiRVFRYfvswIlW8DBg15XdfTiOBUZArKWI3dw=
X-Gm-Gg: AZuq6aLA26E6z4yjXe14aDZ1BDD9ECI5/f786uQxxs87mGAxcOTdNSSU77HfAVAKLJ6
	WAubsHtLbvFmvYSWBuUFFE1JvgjHfSvBDnEuBdv06CZwQVdrEhGvQxMGd1VSlEQiLo0lwY9JtHg
	3lbzJ150sJ9tBYgiiZ4mqD7oaUyYeGZhCoWYhqNWcpG1VgpMJ/4DEIPP+Hxia0SeWP6pjh9aF79
	y9mLpAlsuor48baRkvrE4/8yN8/n9AMmOnKfy+Fv9nUW4ULnuBIu/BiV5jrArzfJR034H0GoTfB
	1nG5lErz0IsQAg32gu6xPogOMQbs1kcXMK1Hf+pceyvhPzpzW8uWPK+T8Gc3LJm5K0C9wa/KZpI
	zyMaoRo4viw+zkXKRfuImE3Ci+nh4imKypjsugIJtZ0P9wdeY+yxjA06yP519o6XI4SHMxmiJG4
	ZoUOj66SQVu++M6Cl0eitGZmlsIxuwcPE4pswVnM4FWk7aorwIaT50zP+75tLbvBDpoC5Uyg==
X-Received: by 2002:a05:620a:46a8:b0:8c7:1317:142e with SMTP id af79cd13be357-8c713171495mr79844685a.85.1769550163585;
        Tue, 27 Jan 2026 13:42:43 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b99fcbsm56868585a.18.2026.01.27.13.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 13:42:43 -0800 (PST)
Date: Tue, 27 Jan 2026 16:42:41 -0500
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, david@kernel.org,
	mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de
Subject: Re: [PATCH] dax/kmem: add build config for protected dax memory
 blocks
Message-ID: <aXkxUR2By_GQ9Qqn@gourry-fedora-PF4VCD3F>
References: <20260114235022.3437787-6-gourry@gourry.net>
 <20260115024222.3486455-1-gourry@gourry.net>
 <20260127133431.671e4605eee807abe84f92f4@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127133431.671e4605eee807abe84f92f4@linux-foundation.org>

On Tue, Jan 27, 2026 at 01:34:31PM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2026 21:42:22 -0500 Gregory Price <gourry@gourry.net> wrote:
> 
> > Since this protection may break userspace tools, it should
> > be an opt-in until those tools have time to update to the
> > new daxN.M/hotplug interface instead of memory blocks.
> > 
> > --- a/drivers/dax/Kconfig
> > +++ b/drivers/dax/Kconfig
> > @@ -78,4 +78,22 @@ config DEV_DAX_KMEM
> >  
> >  	  Say N if unsure.
> >  
> > +config DEV_DAX_KMEM_PROTECTED
> 
> Users must rebuild and redeploy kernels after having updated a
> userspace tool.  They won't thank us for this ;)
> 
> Isn't there something we can do to make this feature
> backward-compatible?
>

This feature is likely getting dropped in favor of pushing such policy
to a driver if it cares that much to prevent users toggling memory
blocks.  

I will likely re-spin this series in a week or so when other non-mm
changes flesh out a little clearer.  This will be removed and some
of the mm/memory-hotplug.c changes will be changed to prevent the
modification of an already extern'd function.

~Gregory
