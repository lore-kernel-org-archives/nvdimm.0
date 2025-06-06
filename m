Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C474D28A1CB
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749230892; cv=none; b=LVSGJwQrSiiMRbusaW1u+fiMiql1kGX1tR1szwIDU4AoTq5lgHRy2AJj/33WSzghrYtv8Ol0HMpcc0seLtboN39NxD5z6q/QzAGoekNa0+aOe+Ad5scBHPTDYsvqur8m1YiFa0/pyeJJjJlzMQlReDySXTLEcRZg+UaXJkbJ2pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749230892; c=relaxed/simple;
	bh=xrcru449cei1Et0aCLQa6/Kqc5VQETIjkfkAR+RpjMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQvmxxPXhCUILlR1TBpGZW68EOnINIQRWh7arN7f5t+0HM4zM3VVm2hHtjXzdRtSzEJQb5b67ou3C1PjHNaPeP/Y9g4UHpbnFsoKBBFjUReSWOvOoQ2ucZz2Iwo7bEvUCJhag/hTUCtVYJiK8FFfso96tfql6OJR0HyzfHHBVsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=nUUKJ5Xc; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="nUUKJ5Xc"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7481600130eso2507772b3a.3
        for <nvdimm@lists.linux.dev>; Fri, 06 Jun 2025 10:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1749230890; x=1749835690; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8bxQcB6I31Y/6ivyEzgwxs7LfhD5ih9mAPGJOZEq11Q=;
        b=nUUKJ5Xc9Xqaslos+VHRNkvvUnKDGUkJXP0IUUwqlIp8LTpi7WZ0W5TCM4FtPCI3eo
         6QKZEZfVHMwzfKyiRmi+lq3QrJdwzhmJvs9u6QZyPbQcVkQP28LtMvLBjsq9KvPV7kGZ
         5OwYcxvQwf5mF+VKT81MNVtaWxHTnFbJMm2LW70MVhghsrFpCYKuq+JGv58f6HtqdNfm
         y0m3CiuDpdZabPiSjsQfIUapiUJMZpoVZnsB/x0tOZ7UOm7kREjpngWkFvMLYyTsywfq
         r6nu5iDhajicD228tvGnu89aEFeJQhDb0BLtBCLpmDs0b2QmtswcwLSe43QzEKGwwW9E
         bcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749230890; x=1749835690;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8bxQcB6I31Y/6ivyEzgwxs7LfhD5ih9mAPGJOZEq11Q=;
        b=f/zW/S4siTUw9j9xpMTroR1zbjZqebNGpWAwc7fmq0Hjob/CdZ8HHzAeZxJqqlF1x9
         g1VAV8lKzhvgvkyYC+rcLpKchcr4miYH23eyb2glFoD55tJD4q7o4kOgyYpfYL4kcrl2
         vuOAfC93dnl0GEPbN8P0nccYcNtEV+6n3r9/AxfYDT8ojKKjxudje9hmaG/ngrE3kiwu
         +CIMvfcpdEA4ETk3GLFsTBl4ID0Op689fYpBcj8m1Fqt8gzMsFUB81wGZWwdC1VtRQnl
         ++DZnezqOB4lPGBRDfsDiw9mCGQommMMg26K0ffderxqTEhIlcScsTx50iiqiO+JN6VV
         UVZA==
X-Forwarded-Encrypted: i=1; AJvYcCXIJPxpNR68lN8EQK/EKOrA3k0B5fSDVyX7sISUyfzY5F3ROXXYkHcRCmTW5njJVZyqO0JediU=@lists.linux.dev
X-Gm-Message-State: AOJu0YydyEbyTZEfqUWXRKs9ZQ5alzB12cxHRF9Wp9OAbqX/gPnRa6Dj
	WlKXx5rsxZskR4+JtUPQ0rXVXhNqMTwWVSmOfFN0l/4XdoJKxbXuJSKSLgLfCp+i5Ek=
X-Gm-Gg: ASbGnct3tgodGnORB0+8d3zynJ4oaVdp/u5eFGbDNLMlJFoNV8AzkjhughLYgiq3Zs2
	PellrT4QIzamKBnZ+ZHntcdAQnaSLNjT/qCGROvgkkan9XwoB1f4PDbg9SCJZCGLsdi49bxqoXN
	4z/Ygo+JCMy6gqZ8p1b1UCVhipCUMZj69Re70adeIVia/wMKKQifUrgkkJ7Mu9Hd58jFy9Rntr2
	RcnYxda9hbFYDxdY1boxAQxBtus3DDUZ69mqhBTGkqU6OzgaLlxn/ZEnC21cIll+h9FbHvsKIyO
	zGb9gBtRKSDTDhYSviqEQxIMXkRibTMV
X-Google-Smtp-Source: AGHT+IEbUQQvWXU//4u2yreY3b/suldCjm0c7NQZ8DRuolXQmMbStt3cnUiQB2khj9JcdjCEds7eUw==
X-Received: by 2002:a05:6a20:729f:b0:215:d611:5d9b with SMTP id adf61e73a8af0-21ee68a05d8mr5562457637.12.1749230890038;
        Fri, 06 Jun 2025 10:28:10 -0700 (PDT)
Received: from x1 ([97.120.245.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b0842d3sm1576428b3a.98.2025.06.06.10.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 10:28:09 -0700 (PDT)
Date: Fri, 6 Jun 2025 10:28:08 -0700
From: Drew Fustini <drew@pdp7.com>
To: Oliver O'Halloran <oohall@gmail.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, nvdimm@lists.linux.dev,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: pmem: Convert binding to YAML
Message-ID: <aEMlKN9/PKTLciLF@x1>
References: <20250520021440.24324-1-drew@pdp7.com>
 <aCvnXW12cC97amX3@x1>
 <20250520-refract-fling-d064e11ddbdf@spud>
 <aCzvaPQ0Z3uunjHz@x1>
 <CAOSf1CGLoN7u18OOPZ_FGiYvxUninoCAvR8CJiOLGJrORCghdw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOSf1CGLoN7u18OOPZ_FGiYvxUninoCAvR8CJiOLGJrORCghdw@mail.gmail.com>

On Fri, Jun 06, 2025 at 12:20:48PM +1000, Oliver O'Halloran wrote:
> On Wed, May 21, 2025 at 7:08 AM Drew Fustini <drew@pdp7.com> wrote:
> >
> > On Tue, May 20, 2025 at 04:51:42PM +0100, Conor Dooley wrote:
> > > On Mon, May 19, 2025 at 07:22:21PM -0700, Drew Fustini wrote:
> > > > On Mon, May 19, 2025 at 07:14:40PM -0700, Drew Fustini wrote:
> > > > > Convert the PMEM device tree binding from text to YAML. This will allow
> > > > > device trees with pmem-region nodes to pass dtbs_check.
> > > > >
> > > > > Signed-off-by: Drew Fustini <drew@pdp7.com>
> > > > > ---
> > > > > v2: remove the txt file to make the conversion complete
> > > >
> > > > Krzysztof/Rob: my apologies, I forgot to add v2 to the Subject. Please
> > > > let me know if I should resend.
> > >
> > > I see how it is Drew...
> > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> >
> > Thanks for the Ack and sorry about that :)
> >
> > Is it now just a matter of Rb from Oliver O'Halloran and this patch
> > going through the nvdimm tree?
> 
> It looks fine to me, but I've never worked with YAML DTs so I won't
> pretend to review it.
> 
> Acked-By: Oliver O'Halloran <oohall@gmail.com>

Thanks for the Ack.

Drew
