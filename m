Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B65F145A1F
	for <nvdimm@lists.linux.dev>; Fri, 14 Nov 2025 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763123104; cv=none; b=icMS8VhzVAIDQ2hZ4X1/y3+3Yw39BjEyr/z1R5p6SwiMCKxzJH2caMOkXkp8CWHC69PPUN8jO1J1sxzee7Utmn7FNGhdAZ0TU86vnBMAkIPNtO8R4JODkRL1/wB09pLVXIC6enfKbkf+EQdI3kea3Q0tmW0jpbis7XKqpOYjv4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763123104; c=relaxed/simple;
	bh=D7DC5uL4Z2X8dZSOZq44ppvBWzR1P9VrOwHfckJIB74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+rKFmZNUKBRNZICu/TjKCP4384nlxdKxCzsPMbdzWk+w4CBJx+DVLG6mZgBkMEa3gUuGZ2VPAqMfmvqvh1Zh5dOmOvZJ/tyyiUgg2GuGOTELeyfOo2rOKT84NikuMo/8k02N1gQkAw+UaBzNNY/5JKhSelzbwl6z2oG9RVRNtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ba/pQdDU; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ba/pQdDU"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-643165976dcso6995a12.1
        for <nvdimm@lists.linux.dev>; Fri, 14 Nov 2025 04:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763123101; x=1763727901; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnqGkWyuyOdPpbsRCorGUws6JHDjFj9s2aEZUULAgcI=;
        b=ba/pQdDUOoPbLRo5p3cU73jY5caqZhPm5TBmnax+awVXtSlGPTbO4wBh5PpDECD8xZ
         LCJJk26rly2b4jcluiyQnXC9r+fscohxGKTJxCLZS2pY5NqM2+XRv8Kn34RlW3P5xa0o
         TNayQ7VyYP9dkMRfibyRUfbKr/O75aiSLmV+na8fydoyh3e90fGVhUoLnhuwHoYqkyR4
         WfajalHd8gX4Psv+P41CPW9gz2eky6HOYbxUUsnin9G8w2Zj/mnyfAcc0d2EOZoytOwE
         MwDRWvnZb93RwxSQ9SjQvImO9sla0babITsAcTr14VS0WJgMUEstViyqrw25FZ5S36pG
         yRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763123101; x=1763727901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CnqGkWyuyOdPpbsRCorGUws6JHDjFj9s2aEZUULAgcI=;
        b=f5vyA0LJBWo7Px44TzkAu7rFkxtbVGdr9+vje7gw+fS/mX0P/y6TUNE4XF3wKv5Lx8
         0W54CZhixxpVaq0itfQJgFZj6MwjWh+nbnaY0jH5PHGtGUttEkb/8RItn99SGVszqbtb
         FnK+keW9sUFy367Lgc+HS1p7g+on5YR4UWXsJWiIi17tUOEXYtIejLc85AFLyXIzOJAN
         8ZRsZklu4b3U0NZZuxiwBT4SFKnhR4gSpFwYjAx5DWRjUBFRmCoG1ASjfRL0FocIbA0j
         cveO6s/eJZfKvjDZsM7kOdLG0Twg5bRiqsYCAF1olQJhV6dvepw6Sl5bQQXFbhy4Li3s
         cS9g==
X-Forwarded-Encrypted: i=1; AJvYcCX5/lDKG3IBcAknVS9iZe2KkeWLZfnnxn/uUdexfLJNuaC9BTJoHakRgEwzZFHydriFHCIEDaU=@lists.linux.dev
X-Gm-Message-State: AOJu0YycJ6VExLn0iDbDo+MPj1f+XWWLQs95DS/ktLOK5JVOGWREF+dv
	hK3Sse5J8CkUz77n/FNPHMizuZN0KjnHKEkUcO4gNve0mug5MyJZYj3Ld6wItuxcYcFlYiQSJ4n
	YdHuG772GPmpipOft2rfFum+Z3oJXx/oXLmNZhafS
X-Gm-Gg: ASbGncs7GCNyglAlFhEruBva9LJfBflAxzsfLpGPosxZ+Sy87dh1ttr9zSmLXrQRRpM
	hT7+7bpU/OVhhCkrLS1OeuRctuJp+2TzSTI3o/PbDF3Pe8VbgmwHbL51Umb/DVCoB9FIA2rRDOd
	cYgo3VbEvXGK1Qtf2VZa3N5yAKAquNd+1Fey9Pl38neJXs9qNASq8v0slXZubAVqgGl+t7b3gY7
	rFadvxn29X/DnM6jbPrtXFMiltSXKt+VX5CaBtDmDO/BIWW+gd+SyC9XzDYKOYejqhTQwiTFC/a
	cdHBDOnd7mBgED0dNZLMsfac2duTk2HmTaOn
X-Google-Smtp-Source: AGHT+IH5irDABmMGZpAhpnUvlVYenFsVwXZ6X2xmt7hHD2N3QUeeQ21yBa4LfJ9O3U3wPXL+fECXsccLV9IYfniWJJI=
X-Received: by 2002:aa7:c4d1:0:b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-64355121feamr44767a12.7.1763123100641; Fri, 14 Nov 2025
 04:25:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com>
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Fri, 14 Nov 2025 13:24:49 +0100
X-Gm-Features: AWmQ_bl8jW_docsBVraFMSwYLTTq5hk31EtHqWGFvt8QiGs4Z3vqGdZ08ivlenU
Message-ID: <CAAi7L5dWCNiD2WOfowdaca09_i6Z2-8xFqatOpjPjA335puuVQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] dax: add PROBE_PREFER_ASYNCHRONOUS to all the dax drivers
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 11:05=E2=80=AFPM Michal Clapinski <mclapinski@googl=
e.com> wrote:
>
> Comments in linux/device/driver.h say that the goal is to do async
> probing on all devices. The current behavior unnecessarily slows down
> the boot by synchronously probing dax devices, so let's change that.
>
> For thousands of devices, this change saves >1s of boot time.
>
> Michal Clapinski (5):
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the kmem driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the cxl driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the hmem drivers
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the dax device driver
>
>  drivers/dax/cxl.c       | 1 +
>  drivers/dax/device.c    | 3 +++
>  drivers/dax/hmem/hmem.c | 2 ++
>  drivers/dax/kmem.c      | 3 +++
>  drivers/dax/pmem.c      | 1 +
>  5 files changed, 10 insertions(+)
>
> --
> 2.51.1.821.gb6fe4d2222-goog
>

+Ira (you're not listed as a maintainer of drivers/dax/ in the MAINTAINERS =
file)

Is there anything else required from my side or can this be merged?
