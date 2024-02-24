Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881A54D9E8
	for <nvdimm@lists.linux.dev>; Sat, 24 Feb 2024 23:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708817559; cv=none; b=pGO5A55SWJdMnDsMnF1DGLL05tMycbOK24jBwHyxEmF0kUzmqux7V/IfW4Dpm+gNxoM+ErRqva3CSFmMOUpZgzoBjDbCBPDhvscJtV6I1OgR9gwTtoxKbpOnSup6s8DrY3Cu9Yp80H/KtF+0uHznTrtePFb1IbBucRYeSn0Cxi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708817559; c=relaxed/simple;
	bh=LEJEA5dmOEKMUGOVAggOyjwSEs5lMEzUNwq2DFUkuYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN2LYxot8lAnqXUz2fdSERN5oTNOO507I7TbeOSmdf9si53mSMcnkJ1rtUSWuk7rBVHPYtZBVed644f4D9gGQuJHdn9+C4zJ00OYP/m29K+djTuHE9fK48R2x9dTo5TeAPlWoMq3VPE8eUCOYYOCNOWesGo7mMo0MlOz/odmb6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BXeSEn5q; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BXeSEn5q"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-21fdf31a154so362113fac.3
        for <nvdimm@lists.linux.dev>; Sat, 24 Feb 2024 15:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708817556; x=1709422356; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NxHV763dz9Q7LJ++FquVhbgQ4BRtn7/8LZkcmHpqxlI=;
        b=BXeSEn5qCFsTxsDw75Oz+8ZVR5IeSyvKJGGXj2SZ7ihIKBNoBuy+l643uTsoj/tfZl
         Ebqnyy75lfSpn3kch2Fjq0/KdUEdWreYHS0K+H6JagTxF4dP/8pMYc9xxGqW0HmKiaXf
         YNYBCdh7E1X7XE9NDv09gk80uSppf6vJTlFokMWRWeKvTIFOtv8iofvJ7cq4KY1kXPim
         z3+03nyq/uDoURjVSbcjaIhUfCmjrrGoCxzO7xnEhwN9yfEvZx3r0KRW5iwa5atiNEnm
         tYiiYiH1unHl5ZS3I58h5KD2MB0ySi2D29WAN09jnICkGApbld24cblfdIQfgU8HpP6e
         Qbiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708817556; x=1709422356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NxHV763dz9Q7LJ++FquVhbgQ4BRtn7/8LZkcmHpqxlI=;
        b=YN4oLHz2EuvjXf4Ke7dlq3dosJhyEWks1LpVUBVE/OczIXttlWkD5loo8t1A+/lgrw
         e4G5jbBbW7NC6tYCedeVzL1+ht7lNXnU2IlGq2jUpLNuPyLziEbiJCXjgxrFFSpoS1oR
         xkDIxvb7pv70Dh8gbHy3SAzSF8JiKUEVBCR/SitcE2k43cbkd9kmWkw47GdclRgI0DBE
         AyRWMZPQHH3ihuJF9q20r1bsQVJ9JKT+K2tsNn4dlgGT0KF0dimgCl3mlSHkHK+xx2lJ
         zDec1nCTxNsKthKT9lknpilnt2Yqtn655FE6CxgUJ1Re926xvvC+uxD4UNIq5xio5Q04
         vaAw==
X-Forwarded-Encrypted: i=1; AJvYcCVFCcOK3JzPson52A31F4rZmlkiKy5vVQ/6XYC9cjr0TfDhIjESatuhkLrP/Jotbo3g41SSV6+JR2zjojqn3io/eE3vtUpx
X-Gm-Message-State: AOJu0YzRuSV9G/EJdFzPvAvPxOWq1NLpg1DmHpmvhTMRBDmZw4ZAbcJi
	czopWoWWc18B6VSBRzsJxG8DBC9vPh3PKIUA9I0IlIL+ARozqbi3hUTTc+zV3uc=
X-Google-Smtp-Source: AGHT+IFgGjRCDoxSg69EZFQFbC7XME7J+69ucMF12PN+7CvU7QfaaV6FrKP1iBGDQ6mg0+wAmxYHiw==
X-Received: by 2002:a05:6871:88f:b0:21e:b98f:4501 with SMTP id r15-20020a056871088f00b0021eb98f4501mr4120324oaq.22.1708817556586;
        Sat, 24 Feb 2024 15:32:36 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id nw15-20020a056870bb0f00b0021ebd810c92sm670213oab.41.2024.02.24.15.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 15:32:36 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sat, 24 Feb 2024 17:32:34 -0600
From: John Groves <John@groves.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 07/20] famfs: Add include/linux/famfs_ioctl.h
Message-ID: <7rkmolss5vkdljnh6uksfkepklwofe3bkdsf36qhokyltjoxlx@xqgef734pidg>
References: <cover.1708709155.git.john@groves.net>
 <b40ca30e4bf689249a8c237909d9a7aaca9861e4.1708709155.git.john@groves.net>
 <8f62b688-6c14-4eab-b039-7d9a112893f8@infradead.org>
 <7onhdq4spd7mnkr5c443sbvnr7l4n34amtterg4soiey2qubyl@r2ppa6fsohnk>
 <97cde8f6-21ed-45b9-9618-568933102f05@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97cde8f6-21ed-45b9-9618-568933102f05@infradead.org>

On 24/02/23 07:27PM, Randy Dunlap wrote:
> Hi John,
> 
> On 2/23/24 18:23, John Groves wrote:
> >>> +
> >>> +#define FAMFSIOC_MAGIC 'u'
> >> This 'u' value should be documented in
> >> Documentation/userspace-api/ioctl/ioctl-number.rst.
> >>
> >> and if possible, you might want to use values like 0x5x or 0x8x
> >> that don't conflict with the ioctl numbers that are already used
> >> in the 'u' space.
> > Will do. I was trying to be too clever there, invoking "mu" for
> > micron. 
> 
> I might have been unclear about this one.
> It's OK to use 'u' but the values 1-4 below conflict in the 'u' space:
> 
> 'u'   00-1F  linux/smb_fs.h                                          gone
> 'u'   20-3F  linux/uvcvideo.h                                        USB video class host driver
> 'u'   40-4f  linux/udmabuf.h
> 
> so if you could use
> 'u'   50-5f
> or
> 'u'   80-8f
> 
> then those conflicts wouldn't be there.
> HTH.
> 
> >>> +
> >>> +/* famfs file ioctl opcodes */
> >>> +#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC, 1, struct famfs_ioc_map)
> >>> +#define FAMFSIOC_MAP_GET       _IOR(FAMFSIOC_MAGIC, 2, struct famfs_ioc_map)
> >>> +#define FAMFSIOC_MAP_GETEXT    _IOR(FAMFSIOC_MAGIC, 3, struct famfs_extent)
> >>> +#define FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,  4)
> 
> -- 
> #Randy

Thanks Randy; I think I'm the one that didn't read carefully enough.

Does this look right?

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 457e16f06e04..44a44809657b 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -288,6 +288,7 @@ Code  Seq#    Include File                                           Comments
 'u'   00-1F  linux/smb_fs.h                                          gone
 'u'   20-3F  linux/uvcvideo.h                                        USB video class host driver
 'u'   40-4f  linux/udmabuf.h                                         userspace dma-buf misc device
+'u'   50-5F  linux/famfs_ioctl.h                                     famfs shared memory file system
 'v'   00-1F  linux/ext2_fs.h                                         conflict!
 'v'   00-1F  linux/fs.h                                              conflict!
 'v'   00-0F  linux/sonypi.h                                          conflict!
diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
index 6b3e6452d02f..57521898ed57 100644
--- a/include/uapi/linux/famfs_ioctl.h
+++ b/include/uapi/linux/famfs_ioctl.h
@@ -48,9 +48,9 @@ struct famfs_ioc_map {
 #define FAMFSIOC_MAGIC 'u'

 /* famfs file ioctl opcodes */
-#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC, 1, struct famfs_ioc_map)
-#define FAMFSIOC_MAP_GET       _IOR(FAMFSIOC_MAGIC, 2, struct famfs_ioc_map)
-#define FAMFSIOC_MAP_GETEXT    _IOR(FAMFSIOC_MAGIC, 3, struct famfs_extent)
-#define FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,  4)
+#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC, 0x50, struct famfs_ioc_map)
+#define FAMFSIOC_MAP_GET       _IOR(FAMFSIOC_MAGIC, 0x51, struct famfs_ioc_map)
+#define FAMFSIOC_MAP_GETEXT    _IOR(FAMFSIOC_MAGIC, 0x52, struct famfs_extent)
+#define FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,  0x53)

Thank you!
John

