Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87B02E5D2B
	for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755276801; cv=none; b=QIeyIzKBf5hH0vv3QJDP4L1GSNBgsrn17XuUPiWqM5MZug2Fr/XCWiAdGHKGyy0HoHKloWSUQuDDKp2/5Krt/6C5Hp7UePgSa6LSW0HC34aXm9ub4CdS+VwvRQuzsi6aCNTG87Z8vIYDAx/rVwfTgzpw7PH+6PtsRg7XxxF8O5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755276801; c=relaxed/simple;
	bh=ncsZMcaEaRyKrG7bCrmhKqxgcGm35QtHCgV+5Alx7ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6UQHgHIg9HayVJkIk9tw/8EVG6zKFw1Fcl1iY1MhQmPAtNqUoA/vph/oR8708FamWVPsiHQS1lnAe1An9bdoD9MhfmaemL0pCpY3FX9UJEhizNxHUQLvzSXcsfDUSc5uZOGq98+idZZOfwIbBSavaZAHG7WV6hdRpRvSecujB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E2rkwTXh; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E2rkwTXh"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-74381e0a227so1536370a34.0
        for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 09:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755276799; x=1755881599; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1YfSXIbwb8SN2s4kprGpkOdh2b7v2KrGx+xJwdVO5E=;
        b=E2rkwTXha3/rGUjaGx3Utq8McV5dmN4SsWIXSkZ2pOhk52Wvs9WnbOo2FNSsHMfSB8
         YvQ8TN+P34ibb+PLQSY4Ieo3tzeW5TLFFPDg47+sq8aZn3bZg6cy0MOrLRqA1mH6Je28
         2JXQQSAe9rGBIa+GbgIrnOdSqZuc68Pjn5Pkkt3M2yu9jjF61gO50TDD6kc0EOEkJta/
         WYCNeq2+EsapX9tjpbN8lhoFg4lgKp3V5Z8Zrk338DZg7oqGpjT764NroHLTP62Qsu0J
         wdkwdb1D3ad4B2/P7Hyyq7jPIimMzBtcm+hj5lCCxd4tU++8SQYxwI5ctRZh2Vc/zG9U
         d6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755276799; x=1755881599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1YfSXIbwb8SN2s4kprGpkOdh2b7v2KrGx+xJwdVO5E=;
        b=PvMmC0DfT8lvAIKmXSfc/sksYiytoujSxkYV35buYBtkz/yAfQNN0/swMmcRAAr3b/
         +jcPrtwtTnEISQnz/OYTcS9XQdCzzLBiWxl9ZzN3uN1azg+52BnVl3lEsw43lZ5+g9fE
         0CQeHobtvN1DMY5aVWxO0aP/f6TZ/9lghB0CjBXleuPs7P2Aei9RdnSqGIUkhrZxHhdZ
         5uh6bKdt352/UsqoZPOUVzeR8DPMcLM07XO+KT/5rPznrzz44aK/vZ4fFIhIYAKUCLpk
         4moh+CRm8uFuacG7oVbhROBKWT3ze6SttM54mmbbvPZb554v3YcrGyrBBIJW5rKuajmo
         friw==
X-Forwarded-Encrypted: i=1; AJvYcCUowadvX6hW8GfdMCLQLZWN6crvfKfxugorjTzvRy7V/w5h7C3MLmXjxg3YlTUrU44flPvnfoY=@lists.linux.dev
X-Gm-Message-State: AOJu0YypBOcNxyemGiAfryZSRfICmOY/zxAOCkMWIIsWzQ9SL9goedJY
	BymGSgTmLSxDUBqxOhk67AvcnjptBE+mgh7z8uZTrriKxoZ7/uOaV2HF
X-Gm-Gg: ASbGncsMXbBi+Hjg8tL9kAytf5/v71ZrGKM5dIEu2ZIIva4TNruFz/1NPflG+HEYbTB
	7zH0Rwo/NGzqJqfAwj99TtwYdgzNvU3j7zXtNqK3eOmhMCVJhE8/p05C/Vn9T3xspt4NhMPKb33
	mYPajVDDAU1h46HWEG8G+72zJfJYeTtNlDku3edzAbGpf4I9YA2ay3WdWjXOmPnabBCJhWh9w7l
	/wUJOcvtQu583HHHBtAPfy4N3OjQNNGzKE0LZ7Lb24RI//mfDokddMd0F/IRKYHovHWQRCjS2i5
	z6yeSg2JPJaTDOHcKh+1CMk20cCllT9w+JrmPrMyO7lzR2pWk7ffdDu4IzpkgnR2MlNKvd+b025
	TL7bmjKz7WeYaGnLlC1YVUpE8KI0LJAeXoaSO
X-Google-Smtp-Source: AGHT+IHh7gvLqat09ID5S5eotjMgSZM/1+QH28GoD8XLJ484jicmNbL1KHnEftKM0DAmNzUxwWibZg==
X-Received: by 2002:a9d:7c8a:0:b0:73e:5cb9:e576 with SMTP id 46e09a7af769-743924963b0mr1268395a34.27.1755276798837;
        Fri, 15 Aug 2025 09:53:18 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:c95b:3a76:bbcf:777c])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-74392073461sm377891a34.49.2025.08.15.09.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 09:53:18 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 15 Aug 2025 11:53:16 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, john@groves.net
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <mwnzafopjjpcgf3mznua3nphgmhdpiaato5pvojz7uz3bdw57n@zl7x2uz2hkfj>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-13-john@groves.net>
 <CAJfpegv6wHOniQE6dgGymq4h1430oc2EyV3OQ2S9DqA20nZZUQ@mail.gmail.com>
 <CAJfpegv=ACZchaG-xt0k481W1ZUKb3hWmLi-Js-aKg92d=yObw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv=ACZchaG-xt0k481W1ZUKb3hWmLi-Js-aKg92d=yObw@mail.gmail.com>

On 25/08/14 04:36PM, Miklos Szeredi wrote:
> On Thu, 14 Aug 2025 at 15:36, Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > I'm still hoping some common ground would benefit both interfaces.
> > Just not sure what it should be.
> 
> Something very high level:
> 
>  - allow several map formats: say a plain one with a list of extents
> and a famfs one
>  - allow several types of backing files: say regular and dax dev
>  - querying maps has a common protocol, format of maps is opaque to this
>  - maps are cached by a common facility
>  - each type of mapping has a decoder module
>  - each type of backing file has a module for handling I/O
> 
> Does this make sense?
> 
> This doesn't have to be implemented in one go, but for example
> GET_FMAP could be renamed to GET_READ_MAP with an added offset and
> size parameter.  For famfs the offset/size would be set to zero/inf.
> I'd be content with that for now.

Maybe GET_FILE_MAP or GET_FILE_IOMAP if we want to keep overloading 
the term iomap. Maps are to backing-dev for regular file systems,
and to device memory (devdax) for famfs - in all cases both read
and write (when write is allowed).

Thanks,
John

