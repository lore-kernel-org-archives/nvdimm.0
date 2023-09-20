Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5E63C21
	for <nvdimm@lists.linux.dev>; Wed, 20 Sep 2023 05:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695188555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F+ocfh7GT6sPk8Xr1E/8KbVbachV3ZoNZj9eDuM/e9k=;
	b=G+mSyPhx/1/bEQt8gUGfqb8FF1Hp/7ljYPxg/bRJWUOnSlUSyinZHjIHiy0jU7VOjBUb2Q
	+WYHpytldFk6MSfF3oG1fzcD2/Qu9VD5Stf3V+mmXzBPMydowVM5LJKyyEc3GpvSGR1cY7
	HL3Mec2hxaMcwJDxxf8za5kEai6bd/4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-a_c3jHKoOSyzewlR7rgRSw-1; Wed, 20 Sep 2023 01:42:34 -0400
X-MC-Unique: a_c3jHKoOSyzewlR7rgRSw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9ade253e4e4so309884266b.2
        for <nvdimm@lists.linux.dev>; Tue, 19 Sep 2023 22:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695188553; x=1695793353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F+ocfh7GT6sPk8Xr1E/8KbVbachV3ZoNZj9eDuM/e9k=;
        b=kCnOPhKTDd9W/8fBC2qQhQPNchqLi56AtV0GaJX2ZWjBOpnhXavMwPGHpf0j/XkLuO
         I+q8mUuR+KZQM10rRACP253sZ2E90BvIwFzZLt8uKHd5woa5LQ18DsR4fx0HdDEPtnAC
         JuyoJcapRqYvnSU6P57CT6lWZr1PeyrUNI5rjFB5zZ9jgC1wpkTuY4UollNupypSvz0f
         350peXET8vndGYDaS97RtpmuXNGXMA5VoggFY5JFkH2JemDPZ8Hey9zIx/prd4Qxn0+H
         JsKagR1ZQZCBrYMpzV+IYOgstg6HltTtUejBKHgBNLRS378MCR9UjWPnPHr6CBU7VUG7
         KfrA==
X-Gm-Message-State: AOJu0Yz0xz86eWVYxROuljmW/fXJS/+kDuR0uFzSVESiWiiSoGAYhIs4
	BakNSGA6Pi2JY+L7nTExl6vikNJM6Q+IZeIo1GleZ7XV7fkfPHifvDR6y8rpAcoDUqcI5Cw+05N
	wfSnZx1rRtoZXQpU/CZD0JP8AteG6iHwz
X-Received: by 2002:a17:906:3091:b0:99c:c50f:7fb4 with SMTP id 17-20020a170906309100b0099cc50f7fb4mr1108540ejv.1.1695188553012;
        Tue, 19 Sep 2023 22:42:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAT9ZVN8SDeeYMemZ4mFbWTP+nr48rN1jiwughS79T4YtEGAvwyXiDVydiD9hrlBVcBIOBiogvgHmRvOSZMKc=
X-Received: by 2002:a17:906:3091:b0:99c:c50f:7fb4 with SMTP id
 17-20020a170906309100b0099cc50f7fb4mr1108529ejv.1.1695188552793; Tue, 19 Sep
 2023 22:42:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230912082440.325189-1-tglozar@gmail.com> <65036a57ea900_35db10294ec@iweiny-mobl.notmuch>
 <CAP4=nvTKFWHZgrMmfWtRmsjBZ8gijktyJ3rpsNyspqZhL8+Fzg@mail.gmail.com> <6508c1ee9595a_3947ba29473@iweiny-mobl.notmuch>
In-Reply-To: <6508c1ee9595a_3947ba29473@iweiny-mobl.notmuch>
From: Tomas Glozar <tglozar@redhat.com>
Date: Wed, 20 Sep 2023 07:42:22 +0200
Message-ID: <CAP4=nvRRTDiZ5ah2Tmawq5traDy1HtS45XWqrxACyG2YXuuDbA@mail.gmail.com>
Subject: Re: [PATCH] nd_btt: Make BTT lanes preemptible
To: Ira Weiny <ira.weiny@intel.com>
Cc: =?UTF-8?B?VG9tw6HFoSBHbG96YXI=?= <tglozar@gmail.com>, 
	nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

po 18. 9. 2023 v 23:32 odes=C3=ADlatel Ira Weiny <ira.weiny@intel.com> naps=
al:
> Thanks for clarifying.  Could you respin the patch with the text below?
> That would have saved me a lot of time digging to see what the code path
> was.

Sent v2 with relevant parts of the BUG message.

