Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C863E638C
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 13:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776172792; cv=pass; b=RGXBkKyr34oD9BmD2gvWVOVK9RmZyQ39UJ2GLgOxVQmWdAuQKsLWpiVRJ2PSIokiRPXa1VIOYvykG25o1dEfQUTlmQB+XcqTk9CQDF+E+7KPYb5NFeSEDncf0jQl0m4pHt7AdOHJPF0R06N7sHQrQAHlY/ywwE4JyEh9tYrLrt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776172792; c=relaxed/simple;
	bh=ryFgEXHGkmMuSpJJwpuJTVtwXQi8vggb0ychK1MApVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1GtLijgpkFojgneuxou/AWYlkF/Kgtu5sdMUHRgQY0yjglvhFSUjuLjF3W6CKpTHD1DG0o4SIMAwk5PgIlD8tACvaeAW7VW0vGpLcnpALPDctN1X8ki7Twlmerb+OUzMkruZoH275wuKCnNTbd7GiyBwX5CVWCv4NxLGLlFcYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=p17g0gXy; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="p17g0gXy"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a7bbe9d0so44576321cf.0
        for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 06:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776172790; cv=none;
        d=google.com; s=arc-20240605;
        b=OzJByntQvvvxCcTmTC9flEqnvsol29rNLPUW99Df6n6ANTStcc4pBqUCZiSSp8ONmI
         JP+CLQ20C9aOf6SpujwK60sElawiMb1lpMgeo/u2KJk8PUQkurOjlCad55sS1KNQemQP
         6frPp/J6wa121J0N17ezBEJyRbSOFSIwcm7aFHqdrlfgVl8G0bqtzPAK2MCzjDVwkYxx
         BPQXRo+beoLp4pilTMex+EgRWf5r1xbTz9X3kxw9IgI8knlcaTKk0KTXTL+SyIlL1zss
         B54EE8Jv4K0Qdv5lzKBHKavpSYYDZFJTTzD9K+kojf9fsIQu6/TSl1fQwmCR1jJVAsO0
         dUjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+CXxVRVcoz/2rqD2Y6nyYCqWM6bYEnwjERb2zuGyero=;
        fh=E8NPbE9yzqfRJIi9ToWZJnQM+C3SOxM+Bx24NzcPj44=;
        b=hnRPAyMKvCgyTXT7/FFmu3DTxsphzDqsZTuAVEeCsT9OijfcG4XZzK/JO3UTIf7uC0
         kH7UIp1VS5jFmYrXYF8SZl/UtkyGn5zsOO/DhrHic5KbEghPxBNeR4CYNb2H3vHM25Bb
         OA6VbUcEXZ3qFADpWlF4cohwdkk4rZRdAFCHLRWn1H64zYr/dnUrjQlR+p9uav6bWO+H
         BxeJ9x7Hf6hW48d+I3ViDshZ/6t/qy0ZyNuDbXkqpQz2eysyYgsGUnQ7AnbqY9zazrju
         tqgiLtyUb0WbjEBcaNwSUf5ga7Mp9MiuSfpdy0lCz54s6xOIVTr4Y/9URz4O7wGzsyau
         hgYQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1776172790; x=1776777590; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+CXxVRVcoz/2rqD2Y6nyYCqWM6bYEnwjERb2zuGyero=;
        b=p17g0gXyD2DeFUw/8/maXizM5I01aPjZlrEXY88OuJEB5zlVkTpOFxSTo91k6IEE+P
         Mzuqn/gJ3MKwm5mvI/EpZiXRJosv8NMZ/EeVrPJ/2bFAu78kww5uQUy9qCLmHxH5jXl6
         8TB8LzrDrphognV+eGUdZhb8O/bXncF6lYGfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776172790; x=1776777590;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CXxVRVcoz/2rqD2Y6nyYCqWM6bYEnwjERb2zuGyero=;
        b=OS8PWN6pDbOHo9aQGlsNiupCitkc/DY7jBfYTyn3k2L10FKUU3TOJVV+F/43mp0YNg
         5zfy/xEg8IbF9mjQ6rQDo3+Ioo9gDiyiW+SqexZ5BBZpf2OnLUTcB3U+IPvKFBLV/Jew
         tLX7Bb0NSxs7N+OSb6EUbNl9q1zB3LF+NCMJHpjSjE0regl+wnGPgmqbKvouvpxO7u6c
         llxAtPdOlzo4/SVfRFgI7+kwkGHd+6zRiT3OD2vxObN5djLtd8svOVkNdv5ZjZHe/w9j
         1iG/0hujaHeCePXWzWAs/RYMPE1AfjDMb4MAEJV/lxB5MO9lqtLf6k+8mTlpNHGi10TW
         COqw==
X-Forwarded-Encrypted: i=1; AFNElJ84EC/c8kZHolVPlQSdXrZlS7gbyqFujACFb/gSMoWVuibpVg5Jq0tWWYBThiNBZkXofjTviFY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzWlJ7omYu1IUoIQfhHpFxoShcsbtGX6ntzQki61QqaPTBHsLH
	hzHNbQquF79T9g90i1L5mvhbKL0eslPokumFtp4KSBJKP0cQGSF9WAWulo2hm9oOUPZYDMMxdPt
	9bsdXmQcX8GvHMopMbU6Gc5bjfFGxHzb5b92I4aAsiQ==
X-Gm-Gg: AeBDieutuSBdNMV8RpEbhcndRIIhjUj8wTXgtzgjHLNcHasehfNuYWojLKexRv+TVfj
	rj1ubTnLM0Kdp9VKKTT3dK5iBNkyq6wz0eIJ44IyfeYGUItstxMMeO8IEQFa4y+cb6ZIfPOLUjl
	OcryMcHn921QK8T/QScf9RbMgRO0HJ5zC3F3pdfnikyGZbKZ5rR5v/ZRthh3MV9h8jzDhSNsk6e
	uerbTY/2ei7ONpkVPMrOXhYq5BdBbqDoZEUQ7Mij5+pHOcAUsVh9Fivv/fdWEcR10ol00cM17yz
	K5GSs93W0U2hXHkvihKIKLkjNy2pkoMuI8m6
X-Received: by 2002:a05:622a:1114:b0:50d:e471:2d1e with SMTP id
 d75a77b69052e-50de471307cmr196909641cf.35.1776172788501; Tue, 14 Apr 2026
 06:19:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331123702.35052-1-john@jagalactic.com> <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net> <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
In-Reply-To: <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Apr 2026 15:19:36 +0200
X-Gm-Features: AQROBzAjmnDDuarHcsoLUx4J604uFTw3mmrQVyJlb1VBhLQLJU1-3tqIq-XH-a0
Message-ID: <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: Joanne Koong <joannelkoong@gmail.com>
Cc: John Groves <John@groves.net>, Bernd Schubert <bernd@bsbernd.com>, 
	John Groves <john@jagalactic.com>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.com> wrote:

> Overall, my intention with bringing this up is just to make sure we're
> at least aware of this alternative before anything is merged and
> permanent. If Miklos and you think we should land this series, then
> I'm on board with that.

TBH, I'd prefer not to add the famfs specific mapping interface if not
absolutely necessary.  This was the main sticking point originally,
but there seemed to be no better alternative.

However with the bpf approach this would be gone, which is great.

So let us please at least have a try at this. I'm not into bpf yet,
but willing to learn.

Thanks,
Miklos
