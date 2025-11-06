Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6BF2D97A2
	for <nvdimm@lists.linux.dev>; Thu,  6 Nov 2025 09:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762420728; cv=none; b=sNnIyLZuTKLZPXbqfj76tIrys+lFPa/L9Z/k/dbbGgKNoonulGbz7cw/ER6Gd9Tnz8QRTBy4SDZz8BzG31YQ80GGoY6GYwgNIYILGUAI3onhnC4m+OExE6TQWRw1vKbz7KNgRpFkeW9GkbKWws/69wsukrZioGVPFwvcW15zQo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762420728; c=relaxed/simple;
	bh=/sxIfI5DRQ3SPvpnSNNK53/FGYWQ1QcBp8l75KlMgVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UR3fpulB2wnLJpx667gRf0Rbl+SJSr1DxnY+se4anzjJt7eNNmll7jNoRl3Qz8t4n3LnwsQahy5+Q0hHaI2zLDc8MAp+eX2Jd3KAEZz0nvB+wUGyYXZij2N1BW6v8cUlwTTq904V//z3q0JDK9tx9PC4uikhwXIN4ieVCY221Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DrZZtnjh; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DrZZtnjh"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-591ec7af7a1so595296e87.3
        for <nvdimm@lists.linux.dev>; Thu, 06 Nov 2025 01:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762420725; x=1763025525; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sxIfI5DRQ3SPvpnSNNK53/FGYWQ1QcBp8l75KlMgVQ=;
        b=DrZZtnjh18/ChYHuAFp+XbNjHRdFXt0/uTd1KiYShIhXzOH/ayHybvEPk9y7jbHxA5
         2bL0etzJm7haiDb5pQIOgP7HYG0HpwtygpA4lLmX39ecDt7I7L9+9AhhfqaCKBjymQTu
         HubXiFvML4xM9hHKjttwxAfBlEPFr7S38uWJ7WFsAQMd8ptA79TACYR2ndzUikM7zrQj
         wCVWxmVDc0yZpVRpGOFfDi20aJG4MJO62SaSOCOC8BSYj16mMZhZP/jYsYjDD99kroXD
         YV25XXvWoz4IQRLoNYGwkiNYSGHdwWmatz8PHvt6QZiqbTz7AvyAwYUCtHslSwqRF1md
         MLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762420725; x=1763025525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/sxIfI5DRQ3SPvpnSNNK53/FGYWQ1QcBp8l75KlMgVQ=;
        b=wCYlBbITT3f4513ia2VLY+3mbhDOeX4ctg+VerduiQfZ1t5qiOoQPlSpqzInsIVOyC
         Zu9Pgu0oz49Ie//anvLf6k3dsYfOdyNVVH29N3/PVJSSDP/JP8PIDeeFXc6W2Wlji72r
         O2B6Q1BYPHbhb84B+EiBZmf6esT1Jj47JHU4yisPlgI99hj1/7ntUFc3/qwHg8Y/VHba
         xtqk1GpTcoLyiuZFhETfKXpbRFIVXvHCG3QhN5S7jtzqF3Crcmi64t9z5XccHFUpI2Ah
         yQJbI4cf29y6+yk4JEPX5tm/oVqL5dmMjAKhwpjZNhQyngj0/rIbiO/KWG5UkNyVbche
         lHjA==
X-Forwarded-Encrypted: i=1; AJvYcCV0NY/+JDwMHYyRxNeFuVzUU8F2vGg9RwWXQpKn9D15j1IT8Uc9ENZefF/iA5ocAiD1zYiJlaQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCC8SWeKSC2b+fEbL4+NxAesK7pr5hxXxzHgiwHmAgoT+Yuo9o
	GJGtCZP0SoZyonCfzeRdkE5ThkjGeGR6Bi+78YofiYyb+VRhY8bn23ToqL/yDx7c4hqtSVxvvgK
	f7grfgf7+bNgQQMzREQk1UWvTvtr3jCdTfnekRr6bFg==
X-Gm-Gg: ASbGncvzABVF7e2i1IpdqGpAT0nrBNr5/5ROMtewxMDs9Cr4mrKkE+wfQH032liQt5v
	2BDSctsaUafeeUGSekzFT9FNiJccab3EQsiTUxF7uwOiNkcRjse239ZOtg26h062H8T/ukNh/lJ
	ljZRWBX8OJv3gEs/qidPdlDWh0KKAk/tzVt8aTLxAiKS8dB7YVDtU+cUBN3iuaRqQ+DF2t+iLbF
	N8EwACcWoi6oEBOPmFTFpL8u3I71AgACrXm+ZdnBX+9ZMRGL0HOS/HzUFgDQiwL6DvBe/Gd2m9o
	V/XHtiQYwk7lmFPwSw==
X-Google-Smtp-Source: AGHT+IHEizlSd4nxQm5RdcjEYi1pREPn6ZYPXoOm+TkllwMNOV+I7Fyvp7fz51MZh2P0YAJpb8THxFnzKnpuHxcM3i8=
X-Received: by 2002:a05:6512:61b3:b0:594:2d3a:ac3a with SMTP id
 2adb3069b0e04-5943d7da333mr2076747e87.50.1762420725115; Thu, 06 Nov 2025
 01:18:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251105150826.248673-1-marco.crivellari@suse.com> <690bc653488eb_28747c10011@iweiny-mobl.notmuch>
In-Reply-To: <690bc653488eb_28747c10011@iweiny-mobl.notmuch>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Thu, 6 Nov 2025 10:18:34 +0100
X-Gm-Features: AWmQ_bkTsYB8TUxbg33EC0EwBhhsRH-lYV4tVnAUtypIfwsfinVpHZBzBTedho4
Message-ID: <CAAofZF5uVBUJ9gpMc-SKzQ0WDeDPeq8dDFm=8HNZaCsNH4rsSg@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: replace use of system_wq with system_percpu_wq
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 5, 2025 at 10:46=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>[...]
> Queued Thanks,
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Many thanks!

--=20

Marco Crivellari

L3 Support Engineer, Technology & Product
