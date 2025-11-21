Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F022929AAFD
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763742800; cv=none; b=DA6XqxCqYmIHREIAUkVPzXV6DF5ubcofnneoc8dTNA/R1Dle9DB7i/4VOBYfgOUyERmZoOZ1xCEOqgvVoqXp5uKF1hQkKBtuOwEnGwWnFozIG7RESnKarcs3S4lVuUNuHyg12yp/dz4ETxUG00O9+HySd90z8ppx9RTbTOq09d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763742800; c=relaxed/simple;
	bh=i8lB6Xhq5qIw2LcR2aiuLwMvtK9l/CCFSlX/E7C3KfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rzKl6hsFRib9ndIRIQJ+mn1A5zquusVrRTSnkFntRJb6L+BhjwZ3CC1pvZDQF9/pQAZ+5UC01TbESZRqNsrkLBwL8LGtJt2KGco/PKny+DHrjdZvdc6YPCEk73nh6l4drlitug1pifd/vXKpKKiPWMCT+LON52DLFoVk6yZKzzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jrGRwIZ7; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jrGRwIZ7"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640fb02a662so9807a12.1
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763742796; x=1764347596; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JzPZ5dDJUXWF4qsjg1CzRRu4TDRFyC7Z3p5Tit9Rbc=;
        b=jrGRwIZ7PwuEXPg1Oldd6eHZ7/9jf4e1L/MZlG9OpbbZpsKLa7LnSWhZ2g6CRfWzcI
         +IPebdxP1WZQkJ9F46E9+krGL+DoFgH74k1Uwt06LSzYGmz7DqYbKGNMPhsUTXgFhi8m
         ka8K7Yjw7xSQ451n3GdiZiOcASdjVti+dwIVCPl8qERvlw4aaCxt0B94CGWZfNil/Y+H
         y6A7gtT9R+6AEvMVzwHN6aETNblMjLkwtAQLQ4fl2wSi4/PpkIoGzSfQmenbej0OwGnK
         5Mz3ksUI0hEc4PdO0W0y0b+YnZWaIx2jOxEVvvSEGuHOeJY92pmrKoiENAiV6NHfGd3A
         lBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763742796; x=1764347596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7JzPZ5dDJUXWF4qsjg1CzRRu4TDRFyC7Z3p5Tit9Rbc=;
        b=bR8GMVNS47Hn5XcrLXogoaJi4oo/ah1D15H0/OAp3dauSKK67OS+eduUXtnaIrtBXF
         6BziRPSa9N5fGNhpPWL03Y9t41bltIGQe1qk+/A/FUe920wUBBWtwa7CzKLW8MjJFWzi
         Zgjl+nAo+qYCWhBGkLuudkKpywtD0EYyW8GpBcg4aromL8RTVeDXleKggJGYxGaICnyw
         aw5B5hY7HmkFERlgWfixcNDMddUSH9ymuxPF7MqZCWwL2lqbcGCWfgrYDUVbRikkLU7v
         xuOvosIPoB6s41frn764XgEGmO2RTBTdWx9KHLaTQef7ZHOoo8EHChZFACW5DBBDF63w
         fdIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDTCg8qHllgTGknXUKyYJSmmw+xiwLJdygL6qceza5UV6R3uAsa/751g1klhseWccvsCnHS+U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeWhbOC4cuWQovkN+04YIa+hMvNImcpukcR2Zkkd6w5pCCj0Iu
	pl//tlsSa1/g0SAgPcVShAHzRw7c+dV3HIFUm9a+Q6bzEVsCnV0lZd5j/qS0D0ygqxikNYRiCPM
	F3SYIGthaRTPmYH7/KqgUfom/slkwEqlwTvHTtzIt
X-Gm-Gg: ASbGnctfgf4Jjn4KX1lLuw/Odjc2KyWQvZwErSwRNbxnMhtDEKpYfnKr8Bjsjjhn6OR
	X3ZLEc0C3cw2On7tZs/XEpE/CgZc8cZlVFshUUtsFGILCNRDvs5TaG7Csg9w/wbY6HhTQu83Fyn
	OpdbEah+yRFMf4zwX1MuMoG+imjjcS8CqwzJd0PVaDy55h5m2bGAqKpjOgN32B0v3Qov/MqFnQ7
	NaKhKTy8UaBt/yT55oLztK5Urwqe0CgWPFFLcOA5xctwLbSdMRDdSDwhs8yd+09MXgjHg==
X-Google-Smtp-Source: AGHT+IFpxSpkHvgiR26r1tEmf7VxOLY1UkCTmNLNhgG/6y5ncF7GrU9I7etp9Olb6Azm/mZLVSBUngvpmUYPrboW9KM=
X-Received: by 2002:a05:6402:1214:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-645548332cbmr42770a12.7.1763742795987; Fri, 21 Nov 2025
 08:33:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com> <691fb94f7aee9_1eb85100cd@dwillia2-mobl4.notmuch>
In-Reply-To: <691fb94f7aee9_1eb85100cd@dwillia2-mobl4.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Fri, 21 Nov 2025 17:33:05 +0100
X-Gm-Features: AWmQ_bmBax4LGJ2h84vcUCeMiOFbAjV3E_6Wqj0TFMrz__FQfZpYWYQp8nAZZRc
Message-ID: <CAAi7L5fMGANdMts8k4NGxJcWYsPmNwy4zJOXJ-t9T7h3h=mjOg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] dax: add PROBE_PREFER_ASYNCHRONOUS to all the dax drivers
To: dan.j.williams@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 1:59=E2=80=AFAM <dan.j.williams@intel.com> wrote:
>
> Michal Clapinski wrote:
> > Comments in linux/device/driver.h say that the goal is to do async
> > probing on all devices. The current behavior unnecessarily slows down
> > the boot by synchronously probing dax devices, so let's change that.
> >
> > For thousands of devices, this change saves >1s of boot time.
> >
> > Michal Clapinski (5):
> >   dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
> >   dax: add PROBE_PREFER_ASYNCHRONOUS to the kmem driver
> >   dax: add PROBE_PREFER_ASYNCHRONOUS to the cxl driver
> >   dax: add PROBE_PREFER_ASYNCHRONOUS to the hmem drivers
> >   dax: add PROBE_PREFER_ASYNCHRONOUS to the dax device driver
>
> After seeing the trouble this causes with libdaxctl and failing to find
> a quick fix I wonder if you should just go through route of eating the
> potential regressions in your own environment.
>
> I.e. instead of making it a problem that the kernel needs to debug for
> all legacy users, how about you just boot with the command line option:
>
>    driver_async_probe=3Ddevice_dax
>
> ...or add the following to your mopdrobe configuration:
>
>    options device_dax async_probe
>
> I.e. do you really need to change this policy globally for everyone at
> this point?

I'll do that or I'll just cherry-pick this to our kernel. Thank you.

> I do want to improve this, but I think it will take time for libdaxctl
> to get ready for this flag day.
