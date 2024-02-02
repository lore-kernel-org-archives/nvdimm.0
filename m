Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FD32E3E1
	for <nvdimm@lists.linux.dev>; Fri,  2 Feb 2024 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706891632; cv=none; b=b+rmeEbiKo6BWtsJISCiwCqkyyUHgD1IZHkdCeC6mX99KPx5MaPfBRqNbhF1uwdoaEi+v2HK/QFzRd9jZ9cZ+JHozkqwu4zm9vJQH9iEf4+UopMxOSTELmb55ihLj4wQ/Ht6mWzUU13vxsyyJmJX9Q/4xnAGrZt7pBFlcOAv4ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706891632; c=relaxed/simple;
	bh=uhlj6Bq5Vf+ptYFkh6gLEAnY74QLGaRFcC6pbRV9cNM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYRoljJ1KAB8J0GV/daoe2Vs1Ar5c9A2eP9/K7h8s+Ukzej8Qwws3mCmfT2b3aZkb2izIy3zoJW/aTZOY4dxCP6iGjcpY43juafW1MkusdB5WLpVo2wOYDSQe7kVamn5KBrgmIy3b3VnrbWMF3hpV1OGDcofsyDpbj8qXBoj9x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-59a1e21b0ebso585820eaf.1
        for <nvdimm@lists.linux.dev>; Fri, 02 Feb 2024 08:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706891630; x=1707496430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uhlj6Bq5Vf+ptYFkh6gLEAnY74QLGaRFcC6pbRV9cNM=;
        b=MEj9FtDhOZurE3bNntmPFoCffhHx7vewk9NCoCK/fMvZeuj/bMTyYU+yr33eWFuHzd
         EImCJ3NSsInw0VRDYIwkk7yXM6rvCnqfi13MIUNR14w9ZxzLoFdsZpPEnhbIf2LVNnXW
         UYtiHAN8Nj8GNT1qUXXiPrTBB8+SNfIeeownLirjOXicGxK/4BDStcqIKcJzrGhJnQiA
         hAuihXnJdGMhccsvKqvueRKmX4skxWHGMmZWAOXG0RA5fxxMCMDps7t5KGRa52dveZqO
         +hthYiEMxgzBgAvvkuJlnVTZqYPMgppxQ0MyCUU/b2ug74iROLClgotAyN5jqjG3Dibg
         /chw==
X-Gm-Message-State: AOJu0YzAsJI9yQ1amIZ/iTBuhlniJ4n0vn5rQ4egf5XMMdyMGCarYyGI
	2a4z9VKkkAjWi5hQRCmJTT/JThp4cgvoftHeAr4P+PO/L4+nvlSxrtZONvpiEjH/MRkcqCHmE4h
	dpBCu0QIU38/L+q55gL18nNKQ3nc=
X-Google-Smtp-Source: AGHT+IH5lbhNXYdvBNW6Z6n3Fh6gB83VX+7ceza1pjweZQFNpcqOeZkwUhLG4lR26gvzCsUTJwL+cw/Xb8a8+aCYyEs=
X-Received: by 2002:a4a:c810:0:b0:599:6d16:353c with SMTP id
 s16-20020a4ac810000000b005996d16353cmr6463248ooq.1.1706891630031; Fri, 02 Feb
 2024 08:33:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
 <6531d1e01d0e1_7258329440@dwillia2-xfh.jf.intel.com.notmuch>
 <ZVt1J_14iJjnSln9@smile.fi.intel.com> <CAJZ5v0hk2ygfjU7WtgTBhwXhqDc8+xoBb+-gs6Ym9tOJtSoZ4A@mail.gmail.com>
 <ZVuVMNlfumQ4p6oM@smile.fi.intel.com> <Zb0O8o-REzAjLhzl@smile.fi.intel.com>
In-Reply-To: <Zb0O8o-REzAjLhzl@smile.fi.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 2 Feb 2024 17:33:38 +0100
Message-ID: <CAJZ5v0hwNKm7bNS8uEhK-GVCibLaHvE75Rpc4oE9cpM6ByGmxw@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Switch to use acpi_evaluate_dsm_typed()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Michal Wilczynski <michal.wilczynski@intel.com>, nvdimm@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 2, 2024 at 4:49=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Mon, Nov 20, 2023 at 07:19:44PM +0200, Andy Shevchenko wrote:
> > On Mon, Nov 20, 2023 at 04:11:54PM +0100, Rafael J. Wysocki wrote:
> > > On Mon, Nov 20, 2023 at 4:03=E2=80=AFPM Andy Shevchenko
> > > <andriy.shevchenko@linux.intel.com> wrote:
> > > > On Thu, Oct 19, 2023 at 06:03:28PM -0700, Dan Williams wrote:
> > > > > Andy Shevchenko wrote:
> > > > > > The acpi_evaluate_dsm_typed() provides a way to check the type =
of the
> > > > > > object evaluated by _DSM call. Use it instead of open coded var=
iant.
> > > > >
> > > > > Looks good to me.
> > > > >
> > > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > >
> > > > Thank you!
> > > >
> > > > Who is taking care of this? Rafael?
> > >
> > > I can apply it.
> >
> > Would be nice, thank you!
>
> Any news on this?

Fell through the cracks, sorry about that.

Applied now (as 6.9 material).

Thanks!
