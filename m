Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B672A55
	for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 01:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752196732; cv=none; b=YFHIBqnrTsL/d7rDakW6aU/29nVU6tg3nowaCV6Cg34cGoQYkhT5uNSBVy49gA75yZ2QRsZXylXhl1Oqa8ONlEDrE0R5ncFYhKHRClZUby/ymcuC9h6B+lVQIl4teHCZBAwzp2xUpb+Od31Gpxf3oiij5H3Y2Qjtj3g3zzTrWDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752196732; c=relaxed/simple;
	bh=R8AABabAlWYs5sROsKxYgIr8UcUVRhflbLr2PL7WTUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCR2DDJkDBlcKGFLeGKRvhpAmVWuGzDWvZmWMKlfbXx6M83yW2xTYjx6w1+aH7yEbv1foQaD3ZQ2MMfUnNMJPw/UxkqqKTpLetSJZNT0g8McRx9JGG11//aosvgGcgx+uR3F0ijdhg1xXLuUHp8fX/o/UP8sonzYVRLf/tMlkv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSbrfjQK; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSbrfjQK"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-73c89db3dfcso356647a34.3
        for <nvdimm@lists.linux.dev>; Thu, 10 Jul 2025 18:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752196730; x=1752801530; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2g0KFXDxtk/APA3qVySJRW2x29mZCIrc20VuPGvJudw=;
        b=YSbrfjQKQLZfwoys0RrEec17o64TvwxD3DSx/ogcJoyXX5xEbGg26XIgyh6AV77rlv
         0hdwQAKMebLrdA8zxxW7RLJwue2x3gh4PE/2/H7Es9oVYtSJAnegES/okm45zsLccRbX
         M8LWyobB4V6ztwfHM7RphKlHtQqtz6KAhZj8vuOY8wyGMajWWzVrA2vrbTAaltmyS7+O
         G0eCLCYtflsULofhlQ6iGqRp+TjQf4AQlKun9ha+6sJpssJiMOtwq/9xKjZtpXaAa1tC
         GYN46L6SmzXjhju98OknPSUNY7U1aZgzSpkt8qoo9SyRSpJJAd8mAIhaZjETOm3nlm9p
         tMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752196730; x=1752801530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2g0KFXDxtk/APA3qVySJRW2x29mZCIrc20VuPGvJudw=;
        b=NB5C1AAt34ypccbxov3HfFI9afbEF7WdauiY4xH7slXXdzY7eMoRHL/TwZsGRBAKRG
         6LfiMkIaTejw1JFu29fmaGSDz9qWniMDci+XKcLrjnWMoGLhqexfXYi3kCti+abJI4wO
         qVuLjI88Fyd70PYLjsYENmweNIa1OJ2B3BZOwNr/1zLzMSartRjoJUK/4l43oXholMUH
         2KGKMgtQLYgYiWmCX4e/1rUGE3BsJ2Qyt8X6/r0I5N0nsULZQe+jbMeOHgY4CcIS/ndS
         c0eCgq/wzFAkq4gdwp6LxhuKRCgZGGpw5zUs38ai8cbHcHHkPKQ1cL8koWbW812aWiOc
         KlHw==
X-Forwarded-Encrypted: i=1; AJvYcCW+UL5nScc4qA890/vVi5J2wM+U2Auq3gofx5SIdt7yN7Igcs4t3+sXARR04/IMV9tp1fN6WLw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzO5n2SBvwHhJ4pmrEVtOSEUZuPF4YoUx6HNlaA/V/FfpgZokoc
	pGsC4EW65KlTQZRJyPtoc+ObkVi9SuUOyjqjgL/djWFl9cSRRgfq1S8U
X-Gm-Gg: ASbGncu4WSVm39nfHXrIapqQWv8XvUyBsXKRb8g2fpwkM42QlOwXXFtXLHbkzTsMf4l
	0lviAML/S0Gx0AJQQdYQGTKrokG84iBFJAdMLsuo77UimtK7bm91J6QZ3No5HhW/mkKF3lelWuu
	WUJlEm8f1f5mlBRBareGVIdARx05gAMlmeENFB9X/X09dxSChOm/BEK9J/oYAlCVJMUCyyhvmex
	U/Echxac4+/wo0prHYmpkPCitqrnZGayGWIuQihqwuP0/rgOSkSrVYrTFL4ZRJB1YftOqsAwjlM
	QtNWkWSSbBMSbAlaAWT+3SmvdwfGwtFY0gqBXpBcZn1ABVt2TnQRcqhFBPJ5SX7Sepr7Y4p+5vG
	UVIGToperWGMF4yNT10RZejG+aqp3Jv6YQhS9
X-Google-Smtp-Source: AGHT+IGJCnaqGvb/J1NAhW1XcF8WESVSsXDnoLdvhZ4+00xo2gwgbnca4tl65tWGfO6KVztDNniiVg==
X-Received: by 2002:a05:6830:6c0d:b0:727:3957:8522 with SMTP id 46e09a7af769-73cf9f2c45emr1252973a34.20.1752196730333;
        Thu, 10 Jul 2025 18:18:50 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:25b0:db8a:a7d3:ffe1])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73cf108af60sm396801a34.21.2025.07.10.18.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 18:18:49 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 10 Jul 2025 20:18:47 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 00/18] famfs: port into fuse
Message-ID: <qcro3gfcssyvto7rtqkykurb6uh5kqslse4zllosk6bukaualp@xmy6jchvm65p>
References: <20250703185032.46568-1-john@groves.net>
 <os4kk3dq6pyntqgcm4kmzb2tvzpywooim2qi5esvsyvn5mjkmt@zpzxxbzuw3lq>
 <CAJfpeguOAZ0np25+pv2P-AHPOepMn+ycQeMwiqnPs4e0kmWwuQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguOAZ0np25+pv2P-AHPOepMn+ycQeMwiqnPs4e0kmWwuQ@mail.gmail.com>

On 25/07/09 05:26AM, Miklos Szeredi wrote:
> On Thu, 3 Jul 2025 at 20:56, John Groves <John@groves.net> wrote:
> >
> > DERP: I did it again; Miklos' email is wrong in this series.
> 
> linux-fsdevel also lands in my inbox, so I don't even notice.
> 
> I won't get to review this until August, sorry about that.
> 
> Thanks,
> Miklos

Thanks Miklos. I'll probably get one more update out to this series by
August. Best possible case, I will have fixed the poisoned page problem - 
but I haven't worked out what the fix is yet, so that's an aspiration.

Regards,
John

