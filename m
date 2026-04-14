Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC34137DE8B
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 14:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776176327; cv=pass; b=AQmT3XUfYUYB05S6voT2dVX+Xn8im7PvciYtgz84iFGIl11UstxZuGGTMGimSIVEgPRjgB+5zhz34+LwWWtPI/8zXdsEKUp7uuf6cq0ahzJQVaXNVgLzyFd0keWOERe0HczRllZDT8ohkMxcyhHXspHk8ecd9hb55dSDrdNzJfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776176327; c=relaxed/simple;
	bh=qR1ARNJXhgZbUhvZNjjyKFCNkW5s8L/UcZxIWeoFM80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Taqyt1cbfPIIRvooiklf3TOhgozVr2ZixlobBuveOoCebFmW4I0ioyMg34UZ7FWT4uBhQRCc58E5pKlDdRJNNaUgXBUXesf2viJKmzv5fW8VHXWxm086fuK4Q5ONzIY3fBGob56VJjUabmifnGiewD2cgJXdlU0QVodJW2FfXh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=pg8r1jiY; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="pg8r1jiY"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50bbc41677dso80720501cf.0
        for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 07:18:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776176325; cv=none;
        d=google.com; s=arc-20240605;
        b=c+lVKM1g0JX1CFwsPXHzkRCjheDwfuElf+cuX4H+KSXbIn9OSGO6AQmEDoM47yRlaa
         VhTfoSWUl51RvBTZCXS2dVlGEhE7h1BpLspz8otEoXXAtRPWB7f0nslZtmTAXIUhoa5q
         0EeIvoKPVBjjCYiceXBL38hThZ4ohCqHFRztdZUI0oWeU47qz5u6mW8Pi+hdDw/ShAwP
         Qob4viOq/Rb6YPOjp0j9mLqrJEwEFcgA5b05+tbWHYd64Xh2F7GBc/rufyBD7vfWoWiX
         tK1NGQf4N1BkPJvD8S9jrFw7VFlRFJzrqQQGSSrtU7aKkkf1r9hEX/MeycLZPpnZfuyr
         xvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BeSg31i3cb+7JrMZOeE8E9eFnlQ6LWh5RGdI+wJ//2Q=;
        fh=5KzlwPfbm4897M1DYbLfE6XB9Y7iMHxJlvnZYHQVESA=;
        b=fqoFavgnal/MujXkPgzCxE/zg+JRprfCmTUKB1ik3mjoJi9bxDuQxooRJyUy4z9SiS
         gV0mBo6/uoTcwJevnQDqOHOo01RmLjgwEl1tgjXuO7R1ZJsTyOb9YqKbFa1gVKGSpHBN
         rm5C0VYAhTmrXE4FavWoE6gGqL5lZ/c246h3cFnmEz/CKS//w0C9BKhBgetLHSL9k7Ic
         M7yk25OS2STD+dff2LQht2y0aBRMR7x95EgvkZLNyzfG1WpptCvE/h+lYVR5ylrSzGVV
         mui6fb/ZIBtL0Ae8wr1P9uRiZiTnWANCDNADgc+7Dd5S6P4KDdK8votaprAqFCV20HSu
         ICfw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1776176325; x=1776781125; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BeSg31i3cb+7JrMZOeE8E9eFnlQ6LWh5RGdI+wJ//2Q=;
        b=pg8r1jiYWUjB5wuhEVqgTrn+x5khemAUOLvHhPyeGkL0UStwFx+WzBmuf0QPmqmB/I
         NU03pZwfa+F5JPDHxhs8UcNaTCdyktrS5hqcZ8RLAQ+ic58SUJ6XU+yPF9Gxab6F6NGS
         BSjy1DtF4+LRPrloM7b5wOoQe+dleXASmhs/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776176325; x=1776781125;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BeSg31i3cb+7JrMZOeE8E9eFnlQ6LWh5RGdI+wJ//2Q=;
        b=pT38hX7qIkQfHOsvUqN8glp4fet7XsEjGy5GhUrlNeiS1zWJbT0QRuCCBLKmHPE4aj
         N+GfBU++LYIoH6BxDsvHx7FmK9u6DP4QdWSpTbXXbPPF1jOLKq9jtZ9svcLod7LGtlc2
         Ori6cJ9G9laDyEY6Iuk/+8UylaGtzLa7SbLOSmzKMNtBG41wA8Geqe/6P7m4Smgn3ae7
         GD+hGR8LU1EONql8Mi4pLNye9qdNEkHMl/xjCmagqEG0GEhY9z2jXtXPxPF3x2nZDrAd
         U1u9UeOusxMhtImhkq8iAt1pNQwIPRB9qqC4NDuRwN3+vMgTORCT0Qata2bWlSbLSZdS
         LIQA==
X-Forwarded-Encrypted: i=1; AFNElJ/IyItgRI5/nXTizEs5dvnL6/j3Tt9VluDmoUJY7zzlHsIdcfBjFlUz4dwBToUn5NGDmBa7z5M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsQPFoAa24F2Apiz9+D5BoH1RrkvKq8w5Xp1nEOAS3jkVMY/4v
	YlFsSW4Cdazfv5JkadnWdTy0pNqfcuEU1Ns21cDr6CnTeQdiRjUW0e+X0xoaSG6ZeY6fOnIr6p5
	BBuUa1RtOLT6ZoHvA0R3FqNoRA31w8q89j+Ex9oGs0w==
X-Gm-Gg: AeBDietf1mne1KFeso3GxCt16xKheKNf03CaRQobfHqMHW4kdu4uckwzePXjSyXfrqb
	mnFcSyq4eDHow/pkI/gDr46Vz0Spu3LLsbsEthhQHMNL6TBTbqjnNP4yPd1EY8KW/MAZHjSWRLU
	9WsxRX8bG1mkyTt22PWYVhI0hy/iyJ1cSzjc3PGFQPkWinT9L7Pnmwk2OwWQpezyUVuQ2Zby2vc
	SrF/WCJZATKsvAejuTPDLVFLJnlawJSqQHuMfolWT+gGJVNYlU8i2hjCaT4rO3LMF4Zn8DoUfJ4
	yKBx5HuYcMMcaj5Y0556+6CoLFWNc20CgLcNoafdKDaFcxE=
X-Received: by 2002:ac8:5d89:0:b0:50d:7135:5631 with SMTP id
 d75a77b69052e-50dd5b959fcmr266547411cf.6.1776176324547; Tue, 14 Apr 2026
 07:18:44 -0700 (PDT)
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
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com> <ad4_jFsR951c2Mtn@groves.net>
In-Reply-To: <ad4_jFsR951c2Mtn@groves.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Apr 2026 16:18:33 +0200
X-Gm-Features: AQROBzCjv32eXkH-VR3uBgnPuhuKjz5ZLSL9EY66Hi1IQzByLu6JpgnFl7pVZ3s
Message-ID: <CAJfpegsCoMMg-Ux3CbBh0d1uqDNg3Fu_8YE-LubwrQ6A-2Cggw@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: John Groves <John@groves.net>
Cc: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bernd@bsbernd.com>, 
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

On Tue, 14 Apr 2026 at 15:41, John Groves <John@groves.net> wrote:

> My short response: Noooooooooo!!!!!!

:) Seems like this is a highly emotional topic...  I suggest that we
go ahead with bpf experiments, then discuss results and path forward
at LSM.

Thanks,
Miklos
