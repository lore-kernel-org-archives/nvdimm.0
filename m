Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD47621
	for <nvdimm@lists.linux.dev>; Wed, 27 Apr 2022 01:54:42 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so3724831pjb.5
        for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 18:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Y3Yj88/S4E8ZGa/qWHr0LRk4ofLiwHbukhngK1ZsVM=;
        b=nV/PF4xGy6BaTieYjbiOR0TgJBP0wiBro4YTwRv9OxXJSaY6hwUOujAD9EMsZeiroW
         KhEUdLSwqREglgHsuC96ZAuBOGtArNK1Wlp6lSZ7y9/pGL5OhHsLZHQdleHzOYEFSsPu
         Beyh4ejVeDqrA0QfnG8EFi6GaQ/y5X4QjYC5B110iwOV6c9O2uLkMRJP93ppvF1OTBsF
         eSFpZH6WV9ky0e4ilx87UsHpg8wTyhGmZdBtEmtoPqWy95OmEIszXe9/q+/SG8JXgZzc
         uZ9aQXxi2syDe1K6vZykg0dbHrK08w/40ZbUmi4tyuk1qXw4KUJUvnQDxeCLMie7Phu3
         CNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Y3Yj88/S4E8ZGa/qWHr0LRk4ofLiwHbukhngK1ZsVM=;
        b=2fnZ3fUhMRDepCj/5ozYb8ALn61f2RrStVu85w/iaTFkvAxO5lsUEKLHrZTegKl1St
         WCsbQKLYCWTVs5wQsSHHitYtH2gCUjah4pKSnmu0avYaWAzB7NZmGLpoUmJHNhEKuvKu
         R+B0MzQlGlUAq7naLMzgTUepOh7uudLgI+7K1C1k+IoxexYm887rZYRkOiNJMi2fAIva
         3eHJpLNjxA/iC60z6CtDH23ZAWkwZInyflMziKh5E2h53mfWewcPaskPGfwr922ZP0OH
         sNa+7A6bl+IH679Xf7tWDhI5X5DuP96mCrehylXc+bjyB1rpUTh1cIrLQXgsHlverMWM
         YSpg==
X-Gm-Message-State: AOAM532L7fV8UuXtSfUht3TGbanzrpgLqGjacBkIOeITKmwzXOFj+0Tp
	7nMV+ahg3oQJqKF0MvHWus9hXe0jKElLiswrdGpS+JsPuxo=
X-Google-Smtp-Source: ABdhPJxCQbC+yHLAGKBeALOXsrgAJiCEKky+es6ypd50tGzP5nN+8q6tYsFewi0YIwPlajL1VZr6iKBdALnxlguUOmo=
X-Received: by 2002:a17:902:ea57:b0:15a:6173:87dd with SMTP id
 r23-20020a170902ea5700b0015a617387ddmr26849644plg.147.1651024481892; Tue, 26
 Apr 2022 18:54:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
 <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com> <PH0PR18MB50716D0F3A25CD25F8ED463BA9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB50716D0F3A25CD25F8ED463BA9FA9@PH0PR18MB5071.namprd18.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Apr 2022 18:54:31 -0700
Message-ID: <CAPcyv4hnj8zeLqZWXRkhVUovFKR-sj5X=P5WM=vwXxjc7qL64w@mail.gmail.com>
Subject: Re: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
To: An Sarpal <ansrk2001@hotmail.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 26, 2022 at 5:31 PM An Sarpal <ansrk2001@hotmail.com> wrote:
>
> Dan, thank you.
>
> Yes that is true but PCIe memory (assuming a PCIe BAR is backed by real memory and not just registers) never participated in cache coherence anyways.
> So assuming my applications using /dev/dax0.0 character device were aware of this feature (or lack of it), would this implementation be the correct way to do it?

It does not matter if the BAR is backed by real memory. It is
incoherent with other initiators on the bus, so it can create cases
where dirty data is stranded in CPU caches while a another bus
initiator tries access the same physical address.
