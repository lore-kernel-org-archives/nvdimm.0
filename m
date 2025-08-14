Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD6F8F49
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 10:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755167882; cv=none; b=D707v0KIDNMefZZ6wASi92vFERW+Pp+iOgLpJGS1pmmtkJzbXjWhTqVQ66aAFr0FCBmtrAx+iUXuNGKfwqU8BUZKIYq4KfFtj3mov8Gc+BR7oFn6KsBR8OL+002SDTlA7yDNSyf0gMNo1G01a/tcR9NqtkkrrFsgYRRxUtxuSvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755167882; c=relaxed/simple;
	bh=XmRNPUT+R3mB+8K5Wxjbt3OHg0HJY834eV5whN3hKlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cImli2dheIxuT25jrCW8MH/7L+pTZxPyX96wKv7hmN0itcbZL8vZ5FlrC79I1sFd1USY+vgD3VTcXVDkeSkKKpjs9l5El9j5QBI7TlQv0eP6V17g+tAF3WcafinarCLfsvcYbBiz+uE7cUuV6/bqjtKG+83KkfvK4OGq04cnsj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SocHT5T3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SocHT5T3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755167880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ox9VSg794T86GyyHHZvdI0EJOqaz4rB8EprvWh10zrw=;
	b=SocHT5T3jUuIAIFayJ64cruqsPP9S9QmJ7kUSy7J/DEnCeA2bmW+jtEShHVddiEDj16vXl
	TKtwcCCUoVDs981FsuPicuVj8TtLNMXwZUg83RY1xgF3m6EYYx48Ce9FFJX+yeeqaPvzkX
	/Z5YDlPUQFzlRGDQI56Yk138dEzljLU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-ltH0WZddOEebDrbPhztF8Q-1; Thu, 14 Aug 2025 06:37:59 -0400
X-MC-Unique: ltH0WZddOEebDrbPhztF8Q-1
X-Mimecast-MFC-AGG-ID: ltH0WZddOEebDrbPhztF8Q_1755167877
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55ce52745a2so338198e87.3
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 03:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755167877; x=1755772677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ox9VSg794T86GyyHHZvdI0EJOqaz4rB8EprvWh10zrw=;
        b=JElILMuLRAl37J/CsQsvn46dOSg8cMwbvrNPnQXDLKKOdiOvizoJMQV/Fwa3jgS3nQ
         RJqU5KwYOKnjCYsE1KvMzOiPZ6EA0IiN/Gtuv0EP66BsM5p6rbbwoXSmH8DSOqJQGtZd
         fp0x7nDupy0lkPGZ+u7ITihQ2KpKHP4TsswPRWbHlk2U14Af22IbZjuYYz21w5jXePTJ
         s9FWvJUJqPvex4Y9CqwVm5OY2Bs/d1D4TohKXKNFh5+qM092heQVNfHQ5FdPLWGnINfT
         P+UfGzCdXihnYXev4s/7uKCcjZhMT94vEA8We5F72zgeg6d3FDCP4Hetpmo7EAhGKqyJ
         HngQ==
X-Gm-Message-State: AOJu0YwxskCWedI5JfBj/6tkOqCvh+vTZvhqC9OyADxDHLfdyng2Vie+
	lLZuNg8dMdgaoSQlrXNknB8LuLmwq/PfLndfRLXjoE9mgYHk9DoyvbUVaLY/K5LXebFDpHezFk2
	JyPB3N1NF0xnc9S/ylNLZ0/oTjVxSGEhEEIxAzOqyLS26fUhTfX94Dsj632sDMuBJsThZQvHSbT
	1WGXRHMPjquvxMZ802HRCiip4fhDap0bRY
X-Gm-Gg: ASbGncvAmW26zShzTd92O6aymO7BCDekM+ECT9y7KhxIt6pnf8jJ6dhC4RnhZZqUJju
	tJjfUDw5kFLzx3zqdW2bUTznnABrOSd8TBP02kav7vnkhbNSeCQSnHYH2dx0K3dAhPyY6TiHCUa
	55ZzafRZPUskhL0QyvgbpScA==
X-Received: by 2002:a05:6512:2c96:b0:55a:5122:91ea with SMTP id 2adb3069b0e04-55ce5032d30mr816019e87.34.1755167877342;
        Thu, 14 Aug 2025 03:37:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWp3q2pY3smOI1UfTvHXbMgpIXg9RBy/l6M/x7NEe1yHnUkqPcfbaze+XqWVraUXQrOZS9W3x/SukErs51Ovc=
X-Received: by 2002:a05:6512:2c96:b0:55a:5122:91ea with SMTP id
 2adb3069b0e04-55ce5032d30mr816013e87.34.1755167876897; Thu, 14 Aug 2025
 03:37:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250702041837.2677896-1-yi.zhang@redhat.com> <aGViCzgmAQLaGnLR@aschofie-mobl2.lan>
In-Reply-To: <aGViCzgmAQLaGnLR@aschofie-mobl2.lan>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 14 Aug 2025 18:37:42 +0800
X-Gm-Features: Ac12FXwpXHYZ9tTQyCC3j0_OJc5okGmY98zi0aJK-ikaB082d86ZMuvD5rNTmEM
Message-ID: <CAHj4cs_GQG2PNOY5Y3dyTfWbKP6CKcJ5GW+jdS-ZCjt_kryJVQ@mail.gmail.com>
Subject: Re: [ndctl PATCH V2] Various typos fix in Documention/, cxl/, ndctl/,
 test/, util/ and meson.build
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	Dave Jiang <dave.jiang@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4B8RvNJ1by3jDUcWEx_95s3P5J0U_MDjtTgAbKcKtBc_1755167877
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alison
Sorry for the late response, I just found this mail sent to Spam.
I've sent V3 based on your comments, thanks.

On Thu, Jul 3, 2025 at 12:45=E2=80=AFAM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> On Wed, Jul 02, 2025 at 12:18:37AM -0400, Yi Zhang wrote:
> > Most of them caught by https://github.com/codespell-project/codespell
> >
> > s/divdes/divides
> > s/hiearchy/hierarchy
> > s/convereted/converted
> > s/namepace namespace/namespace
> > s/namepsaces/namespaces
> > s/oher/other
> > s/identifer/identifier
> > s/happend/happened
> > s/paritition/partition
> > s/thats/that's
> > s/santize/sanitize
> > s/sucessfully/successfully
> > s/suports/supports
> > s/namepace/namespace
> > s/aare/are
> > s/wont/won't
> > s/werent/weren't
> > s/cant/can't
> > s/defintion/definition
> > s/secounds/seconds
> > s/Sucessfully/Successfully
> > s/succeded/succeeded
> > s/inital/initial
> > s/mangement/management
> > s/optionnal/optional
> > s/argments/arguments
> > s/incremantal/incremental
> > s/detachs/detaches
> >
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
> > ---
> > changes from v1:
> > - Add reviewed-by tag
> > - Add more details about the typos and how they were caught
>
> Hi Yi Zhang - This update does not address my feedback on v1.
> Please check that and ask about what isn't clear.
> -- Alison
>
> snip
>


--=20
Best Regards,
  Yi Zhang

