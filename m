Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F7E2555B
	for <nvdimm@lists.linux.dev>; Sat, 25 May 2024 22:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716677692; cv=none; b=uVseuOOAvxM2OKpIzNbgLVOySXUAfDdhSaGIWaicTaZluLWyE4SQVwfOo1uNUCGZ8zpGjpFx7iw//pS04MTC/54UU67ZSHfzmQxPLBeB3K5yqe9RaJN73OdYWjNh/X51NyRSmOchMb/O2LTakpewMIMDrFUovkXOyLTDnTWYSuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716677692; c=relaxed/simple;
	bh=2So4wsJ4xPrDNuBQCitTz9SGIXIJfHFTKO8rs9jyN9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cw+jAzAwe5EV9xXchvfNrKO2mjWp7Xhd6dBv8Tjf3/wOwAfy7Zsp72ZL2CMI6D4VXuh8pdw/If8qhIpbJyk7z4aQFzM8NoU8wrcUYnoCwKoPvOTp/x8aSw/RGlEM56yfcBlooPvaQ/5Y0ymBjfB+SBRzVyz4uTtl3bDpeBrBhis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=PKH5BXit; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="PKH5BXit"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f44b5b9de6so15082255ad.3
        for <nvdimm@lists.linux.dev>; Sat, 25 May 2024 15:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1716677690; x=1717282490; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=weBCb6P6ludBpc7zn9AlObj/fNR5H8QjdFVNqQ+luR8=;
        b=PKH5BXitVy3JuMjzCB/l+C6uW4QCdn0TcuQvJXbz4CNyGWPH1nrbh8OD+EgnEiinNE
         TyrmMIXAbKiC3+lNLNPRtklxiEwbECiaECVQeWlrf5PIVsjEQqK86vdpSqu7VC/5EBqn
         I8dxGBd/rZWs+dM1oGH12Tf250JYJHe9sA9tXqBbwEHWS6PN9B0wbDLdsGYxjjaSfksX
         8NbRxrp2TElYzO9oEQCsi+Ekix0uCFT7VpLcihAsD1UVzg+sLiPHFzH92X/l4RGFkmp2
         kuihgkmb86z/eld1G4tdxqixtKtiyaTCPgAk5X9qtMYPKF48A7BmTmoUzA/b2aYFwtAV
         g5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716677690; x=1717282490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weBCb6P6ludBpc7zn9AlObj/fNR5H8QjdFVNqQ+luR8=;
        b=KYbYGvtZxIyuJuB8+SuQdCojMqfmWzuwOUSKC5XCtot7f0lm8Mhw1ckPnVJnepAALZ
         MltVO35faybbi42TWk24CNllerZKHDMItvAJXYivOtY8A0808gHusn8XrrMRthY9NlPx
         +BZOteevqvqU35+0gIxEzAuUkBbtaYgrNnqLksuHRmvPi7hfzWUn7dczjULgGFoMYs/t
         aJogG/cnaZCkfUmXZHXbIVgtxODO+s1GUtIkIzcAHkpbZInKY3TLmvcX1A8Rn+ckw2fD
         xKuSTlE9xR2FeU+xuRr1UsjJTj08EIvQQAA121UPFO9LsG51d19dM2pytmJHPeiKjTeH
         rLHw==
X-Forwarded-Encrypted: i=1; AJvYcCX8bew1VOG8k9q0rI2Y69Uz6ibRC9NyNT/eEtKnn3O3NQF6gE5ak+6OXdTpQLGZFuXz31+IF5D7oVU1RmV87ejKFed5cW+u
X-Gm-Message-State: AOJu0Yz2lrCn8jebt2ldmVNSZ+VyKG++XZ2SReDQG+WE5OSCsm502SgB
	AXTabMYY2YYSO5HUeHDVthE8hsgCFUJRsGFPnDcW6c0UYjBPqo4vtgR3Dyczkm52SljBphSiSJ1
	I
X-Google-Smtp-Source: AGHT+IG/lHGnCD9oi3Dn5lyNWSi2pcasUq9NKxmb3YkVSCkUNu19nH/tHbTv71gxdU7NicaDyWz0tQ==
X-Received: by 2002:a17:903:2447:b0:1f2:f8b7:60d4 with SMTP id d9443c01a7336-1f4497daf6cmr66964375ad.52.1716677689821;
        Sat, 25 May 2024 15:54:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c967a62sm34768845ad.120.2024.05.25.15.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 May 2024 15:54:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sB0Hm-00AU4L-21;
	Sun, 26 May 2024 08:54:46 +1000
Date: Sun, 26 May 2024 08:54:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: John Groves <John@groves.net>, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
Message-ID: <ZlJsNir3mBUK0Ofb@dread.disaster.area>
References: <cover.1708709155.git.john@groves.net>
 <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
 <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
 <kejfka5wyedm76eofoziluzl7pq3prys2utvespsiqzs3uxgom@66z2vs4pe22v>
 <CAJfpegvQefgKOKMWC8qGTDAY=qRmxPvWkg2QKzNUiag1+q5L+Q@mail.gmail.com>
 <l2zbsuyxzwcozrozzk2ywem7beafmidzp545knnrnkxlqxd73u@itmqyy4ao43i>
 <CAJfpegsr-5MU-S4obTsu89=SazuG8zXmO6ymrjn5_BLofSRXdg@mail.gmail.com>
 <sq6fbx5jpzkjw43wyr7zmfnvcw45ah5f4vtz6wtanjai3t4cvk@awxlk72xzzkm>
 <CAJfpeguLoO9ZfmJyqSO-Bma+cTyLaz9rDLv-mtfeNa1qGBww+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguLoO9ZfmJyqSO-Bma+cTyLaz9rDLv-mtfeNa1qGBww+A@mail.gmail.com>

On Fri, May 24, 2024 at 09:55:48AM +0200, Miklos Szeredi wrote:
> On Fri, 24 May 2024 at 02:47, John Groves <John@groves.net> wrote:
> 
> > Apologies, but I'm short on time at the moment - going into a long holiday
> > weekend in the US with family plans. I should be focused again by middle of
> > next week.
> 
> NP.
> 
> Obviously I'll need to test it before anything is merged, other than
> that this is not urgent at all...
> 
> > But can you check /proc/cmdline to see of the memmap arg got through without
> > getting mangled? The '$' tends to get fubar'd. You might need \$, or I've seen
> > the need for \\\$. If it's un-mangled, there should be a dax device.
> 
> /proc/cmdline shows the option correctly:
> 
> root@kvm:~# cat /proc/cmdline
> root=/dev/vda console=hvc0 memmap=4G$4G
> 
> > If that doesn't work, it's worth trying '!' instead, which I think would give
> > you a pmem device - if the arg gets through (but ! is less likely to get
> > horked). That pmem device can be converted to devdax...
> 
> That doesn't work either.  No device created in /dev  (dax or pmem).

I think you need to do some ndctl magic to get the memory to be
namespaced correctly for the correct devices to appear.

https://docs.pmem.io/ndctl-user-guide/managing-namespaces

IIRC, need to set the type to pmem and the mode to fsdax, devdax or
raw to get the relevant device nodes to be created for the range..

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
