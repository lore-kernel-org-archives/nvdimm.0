Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A266341754
	for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 13:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776260103; cv=none; b=G4CazVdvNflLGG42wouJO2TXyoLAKHx1IWv/vsp87Ab7wMNbde11NrysEQa76CX/DPV69xt4ChgXA4PtF3AGSF8eHbTIELfGGAD7DA855nAwSiAsw5Ns1SDJWxbneOgYYBvARaluoj4UMElJC7/GZUwfJZj6xWAVcQD1EIYi4oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776260103; c=relaxed/simple;
	bh=t+Xy3C2Mbde6Vr6fstEOcu/315GZEmI8mjVuAP1RX6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ws77chT79jcHrpUHH+n8j7bvr1XIypPg70VfF4hyY4pD7qu3cEwkgJVNR6QG+Y+ByFx9q7rVp9t/79orM/rw67dhpckJQexeBzPp95iXU/SrF9Ou7zd96ill2swwvzKoYVlYWKVVpoxZxhUBgKU4/CK2yvk+R/FG+sxFbwKIU8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=mDpVsZUb; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="mDpVsZUb"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50bbc41677dso93582161cf.0
        for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 06:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776260101; x=1776864901; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6GdYNWBfaWYhLIdfOtbeuO4AqRlccwz6nlSiifbQOw0=;
        b=mDpVsZUbzAPGx63Jpld8CkrQxuZNw5kPiHfVSRbxYIQL9DFhGeverOc0SYerFYMD72
         LstBdpSuWw0WeWx8kcPZTO79xgcNPf6MBJfnx1nXSv9l7qRbCya6vJ1p3GDgnTAV7Stl
         jiFjGvfnqrppv36cjtfatuHyhSSey00bUxrEJqmSf9Zu1L1gaQRLhQOtFDdkL1BxxHI0
         RIEMfhfuMZo6z58NpVJm1t3evURNFRLhtrwSDtk8meslJraomMK9eJxBmobtYQ/4yi7/
         96AYVvNC6Z/SUsGxBXFETYiZd43+mMXJzThSdHVln878Hll6li2fe1fa3eGgs88D1i0C
         eUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776260101; x=1776864901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GdYNWBfaWYhLIdfOtbeuO4AqRlccwz6nlSiifbQOw0=;
        b=HB2ea1kYiKdXKH1r0d9mmccvwzdoUPnPlovVHD2CfDANhpZzui9c4GsirlRgWxtalA
         4+UktmYJg829gfGdzsDz8a0FlOppqKTs9xVJgWG+QNCczEv6/dUKdLGDY5XrSNGD/cZJ
         Ww/9cNxShVJnhV/Blj8sRME0cjzo8s0VRo98Af9zAYITQJ9Kw3tlwORjkwHYLF19OuR4
         xWbSpfaLBzf0YzNcBku+sFpHdDrvNtJhPGR5YheznPVBx51tf6aIx7X05mBvKNLt0eUC
         UtMBQ5klloPOjmVJUR2U7m4Ru5d7eY/FefHBsPzxIkTs6eZAza1rWKJ7CuqSCZjjd0R+
         RHqQ==
X-Forwarded-Encrypted: i=1; AFNElJ+V8mQ8AmIvcXNs3QQyNFYwymLfOb/fN212ipvbWegYMSXpMLjlS6fG52m6BmflnuYMMseN3Lo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyBe9poLgluWnbcqeJ5PmgvB54h9OLuoSv5rk3DwsepOFpd67k
	tNZ706G0SQwVEtThrEdxSzJ7MG5He7is3XhCeUhAMbe4aMRPOSy/jKmYr6AzpE+JuvI=
X-Gm-Gg: AeBDietLFlK2Phtgldsr9bEzo2JdLgmOyehlUHFZyfXwQubk7hYu2/MvFxr/Taiz8pt
	UJqDF3J3NUwaNOjU8QMjr1CTQfZcXfgtQdPEZ0Rihk8LTL6C44U7ff2PaFcqBlyMRNbkx15S1qb
	0b+v7bUoZTCT7GUpbUzh8osxGKXWnr1i8Zjpqqv9nxkFUg/QA4vviWoBjCz5BO9vQXN6LpKN0AL
	UnoR6zcQeQW+mKp2f17I6pHFo114G34mOm4k0WPV0KXaEaQrD+juuQOQL452431hXBstez2l5xT
	O86uuTD41NP9HzKQnOls9/IeQER4VSb2MVCCJ8FFl0mcJUfAryt0OxhrjB5PQ3xNqmlwzpi9RuR
	XiDKl72g+tstjAoFDLI1QtdlI1hoWjMcjzk27I8qaQzECHUlycWs0K6mWKUv2GbNemGBWDm57+I
	/jcETiEewFpdjdW+LkDWYf6ayCioYv5rCcUTM+S97pSfd4D2P+DgA/FSsHVj7RL1z/P5p/CveYt
	ed5IYUxbXls87WcxVbBC94=
X-Received: by 2002:a05:622a:250a:b0:50b:6b21:2bf7 with SMTP id d75a77b69052e-50dd5a44875mr321999521cf.0.1776260100492;
        Wed, 15 Apr 2026 06:35:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ae6cb9ea1csm13877066d6.28.2026.04.15.06.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 06:34:59 -0700 (PDT)
Date: Wed, 15 Apr 2026 09:34:56 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, John Groves <John@groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <ad-UAMcALRubBcHk@gourry-fedora-PF4VCD3F>
References: <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>

On Wed, Apr 15, 2026 at 10:16:38AM +0200, David Hildenbrand (Arm) wrote:
> On 4/15/26 00:20, Gregory Price wrote:
> > On Tue, Apr 14, 2026 at 11:57:40AM -0700, Darrick J. Wong wrote:
> >>>
> >>> I very strongly object to making this a prerequisite to merging. This
> >>> is an untested idea that will certainly delay us by at least a couple
> >>> of merge windows when products are shipping now, and the existing approach
> >>> has been in circulation for a long time. It is TOO LATE!!!!!!
> >>
> > ...
> >>
> >> That said, you're clearly pissed at the goalposts changing yet again,
> >> and that's really not fair that we collectively keep moving them.
> >>
> > 
> > This seems a bit more than moving a goalpost.
> > 
> > We're now gating working software, for real working hardware, on a novel,
> > unproven BPF ops structure that controls page table mappings on page table
> > faults which would be used by exactly 1 user : FAMFS.
> 
> Are MM people on board with even letting BPF do that? Honest question,
> if someone has a pointer to how that should work, that would be appreciated.
> 

This was my first reaction when I realized the BPF program would be
controlling iomap return value in the fault path.  Big ol' (!)  popped
up over my head.

~Gregory
