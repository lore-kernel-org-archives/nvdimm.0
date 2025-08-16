Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA712E9EAB
	for <nvdimm@lists.linux.dev>; Sat, 16 Aug 2025 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755356428; cv=none; b=lxLjJMuSXe+ZdiJQ99M/wkI6rZe/VhO1dw9Y2liDlpMX6kDkzxiXpMgDhXa4eS3b7tBhfXeMD9FOvEuLM7HalNgduw7w0uNcK8V23hPM8nY1tGC1VIEdmhjxxHi/ZQ8oHjjRRJFxzqgMDixqUCdr1CD+i3f4iCOmAIo2TYVNueA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755356428; c=relaxed/simple;
	bh=VigReBL8M6MI529Z8Xk8Ix7rUQBlX7NkF4iKwyADbaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5ijLIhlLMVGJSGaKp2pLMzjJljEsU5Ukty7swrVFvGRZpCNieycy5gz4grA6MhsjjCZ3YU89kll7Sr96B0zeOMbDvvXveunNdJaolTZhCSTKfyMwohEY+nHoE3nfgiLIGtw7rigQV8fOFusOXbtrPLC021sk+YvEwG2IUXvEXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P+FJvQMb; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+FJvQMb"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-74381df8cf1so757350a34.0
        for <nvdimm@lists.linux.dev>; Sat, 16 Aug 2025 08:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755356426; x=1755961226; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwjPbg8KA3rFGnPGiayWOqsstlBug/9B8GI8n0PblXs=;
        b=P+FJvQMbKgvirfGQII0VU++zOUTKssnode/hcYUQHmOgtGuzTWmOhmRV+J87AW6E7a
         Bt+ra6rZ8Iiz+Y6pr5nfTX487bB/6WN1HvH5t9WU/pf9bSUoIiviKEobuY5D1OeubgAu
         SCQI65YS8gsfxrPYzrtMUyob7qnSZ3vrQAguX6LfBRuXhT3F8aO5QVnvaHW4KzCZ2Syl
         mZ6EmyWTbZoY7lIlJPyVE1yHmgXh6Yb7chyEs75GWnTziKGsASOwtfmwH+S1V8T/ZB6q
         fhKy3aJ0QASVHdTgKkJVuc9LaGc6+9yhnODycNlKUcI7ExER0dgfEYaRnOKUqxqPO73P
         VIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755356426; x=1755961226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gwjPbg8KA3rFGnPGiayWOqsstlBug/9B8GI8n0PblXs=;
        b=lVWOyqtx2HUjImTAFYjlMcviTNX2pUtFclqI0/vzRq1Zq05khO7q6PrvEkNMQfbBbk
         z1N2Z5VzxWlazgkJSu5ekGtQH/9gfhlS9xDdHoaPw7CasbgAa0/WbiMsoE9nI0UHVsI8
         5QxIVh9z7JNEC+oHPxlA3vXMCwqbAoPbt1HSX+gKexBs1/H7c201DwtH8i3Z+LRqefsv
         JSx1OC8vQ0INTM0ijOuqT90po21OTXCb3Wik2rSc+CZY2tXJPQCWkOiwrkW+CXvcihzN
         yDeciCH36yjGrdCySqumltRmUB9uCJkjFLR/89Y5Wmz+H143nePDf/lYWC5GVdAP57N7
         MRBg==
X-Forwarded-Encrypted: i=1; AJvYcCUAH5+q9euQG0Vi7eXgyXmqpxe8HOnIPSY1IBlSg2UZ7lXP6ClwV9VDsCSQXbImUbYrqH5R3k8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoSXy7UI5E0Slz4HlosbxL7rP8csPWq4iZNdsGqfsBD3Bmk5MT
	mU5Mo48Jr0NeWKCCOVhSjbVteDW6jGkd6nihOHxLvfc9lB3Pue+WLj30
X-Gm-Gg: ASbGnct8yZ6mz23wlY3MPvGQOkrIZOGs7VXUeFhebTxnH/1v/nx4MgbiPClCwP/wG91
	6KbWNGV3kz+ZiJgFwJXMjnRcLzKzWv+7jj9YZaDgVJRNXn4f0OAhWkDoEdLthzrtcNdlSS+y9mF
	KXkOihqxCYTGaevmMBOT5Z2+ZxVdVg990V4yxUcaRtbXNdTNJ3rKHrHeRFOKfMRUrYww38m4SVQ
	WLHnM6+X3ULqc8lam6TiLVAN2cq9JXtSRE2QaF7FF1gMi6mRpGgI64GzTD041eFbj+Ytydrcgvo
	JSUCul26KsxfbmxmysswTPWXi5x/WX87Xtoyk6vCHCQ+z5rcsrW9gGtHUF8bdNQs7wXLSmWUyq8
	v9cVgaxep66zqMv2Shq4QOCGuo8/uMsPaZ/PG
X-Google-Smtp-Source: AGHT+IFFQO6oO7eKhRJoor1ccKngWoereGVcBCKxuKO/JrshNXE7oZADMU90CYmE2ChdFmofXtpRPQ==
X-Received: by 2002:a05:6830:912:b0:731:e808:be5f with SMTP id 46e09a7af769-743924f57b2mr4023050a34.28.1755356426238;
        Sat, 16 Aug 2025 08:00:26 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:1d43:22e9:7ffa:494a])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-74391bd220fsm881978a34.13.2025.08.16.08.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 08:00:25 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sat, 16 Aug 2025 10:00:23 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredb.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, john@groves.net
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <a6smxrjvz5zifw2wattd7abmxhsizkh7vmwrkruqe3l4k6tg7e@gjwj44tqgpnq>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-13-john@groves.net>
 <CAJfpegv6wHOniQE6dgGymq4h1430oc2EyV3OQ2S9DqA20nZZUQ@mail.gmail.com>
 <20250814180512.GV7942@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814180512.GV7942@frogsfrogsfrogs>

On 25/08/14 11:05AM, Darrick J. Wong wrote:
<snip>
> It's possible that famfs could use the mapping upsertion notification to
> upload mappings into the kernel.  As far as I can tell, fuse servers can
> send notifications even when they're in the middle of handling a fuse
> request, so the famfs daemon's ->open function could upload mappings
> before completing the open operation.
> 

Famfs dax mappings don't change (and might or might not ever change).
Plus, famfs is exposing memory, so it must run at memory speed - which
is why it needs to cache the entire fmap for any active file. That way
mapping faults happen at lookup-in-fmap speed (which is order 1 for
interleaved fmaps, and order-small-n for non-interleaved.

I wouldn't rule out ever using upsert, but probably not before we
integrate famfs with PNFS, or some other major generalizing event.

Thanks,
John

<snip>

