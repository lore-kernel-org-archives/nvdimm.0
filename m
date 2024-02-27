Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B837654F8D
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709056108; cv=none; b=G2tKeWakZoATtRLKMv+MdPYd3ul1/gtQHHj//WcqjouhtdYr4Ug28T53jqBY1y8Y6giQQf4av6rbHay0IvsmPmpFxOq4xZIrNWwAOvNq6EuCZtW7ZLHJr9B3GvK/GmQB7EWsaAsQGUusVTQgGBBuRPl/fwfzwauzeRYwGzuLbQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709056108; c=relaxed/simple;
	bh=vl3+kSJl9raKx1cJiC5v+Xip2F0XB4SZhKZYPl7v7EY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GdlN4+hO0X+uGygr58HDuWUSZwoSfLuuWwdMGKUfWsT4Q94/BYQPHQA+6iVctKYDya5tOOTkphoJr+Za1DLOP68I8vZvRieuh4dSt189EyTZCGyQkBuX+SRRBZ9IO4WtgtZ2Qg/OYU8gjiQ/s/PGyEA04qMB6IubAynVDDJ520c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mig53A7v; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mig53A7v"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a431324e84cso335025366b.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 09:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709056105; x=1709660905; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8aAOEt9j8cLf7pCbr5/djJex7kLy89KWqOPb/rg1GDY=;
        b=Mig53A7vyBnFqPUQrfkRcOqEC2jcXWvvhhWl0wdTwXqYla83pvoJDSkDz0cvldoALi
         B3MiISBq8VZ3VPpjl0EJJwTnd37qteLFOOWo1sRn+CvmSuoQtO0Ttmr+/d8g2Px1FGFC
         nAc6y9t+nzf2mYSxmpZi1axTv74hgP9Txa61Gq2U7o4z8Wt6cDOJlzLUeiEkBrmOh5Jz
         ZtKjEric7PjzznKjUWqmbvTDHYMdrqbV9FdzHLkRs/NaQNh54Xv+fwU1a57Nj4en03PI
         LUtaTWqG6V5fZFuh5oUsrpEJ1PgZPTJoeXyuxziYqM287GThxQ4mWFZi1b6+EqS8d+R+
         vp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709056105; x=1709660905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aAOEt9j8cLf7pCbr5/djJex7kLy89KWqOPb/rg1GDY=;
        b=uATUycSN0a2u1eMHvVN0Ae4CEhOoEhUtNzftzUdxpmCngZUn4bCdbA/RFzh/BWACsH
         raLv7EHJQYvL0AI7OrFVoQ/RRPFShyO3idfD4uU/XwBzdWJp3h3zI46MyH0jWVsNT4Ih
         ehuJVnVa8TkRJn4IotrJqcZeXdpnPTbxZ7QzP/w8nX14LflSobxDE/k1tLWpFDJpGvOC
         x7tTGimDF8AIl5VzvhpPbyHtTQ669SL2A6Xj0RexFWcyY1xsIbdbob28kwXzakFFX7Pu
         DqfWfcSuO7g79KZ3vrd46tX/ZKuKmU7GvaFBVVaCSE3xMJ09dK29YR+NzbFt1cjgs6hv
         6pIA==
X-Forwarded-Encrypted: i=1; AJvYcCV8dFcRjjlvLQUKwiKJx/VFDhARyYkvmux1VDsvaQFmrv8wXMa7ihNK7jrsVcb6zWGgjYwNvApn7pgYJcwOzDgsjcqEFWsV
X-Gm-Message-State: AOJu0YxlT0j6EMax6W5utquP8aOHK1mWL/0ciubOAZ4dkPPdYcUETKvB
	9qpQT4qWgBbBe0l8Hsw7SZ/YCgnKdC36ARy4zYb1OkG5RQrO2kRR
X-Google-Smtp-Source: AGHT+IEBmzlxvbwk14gM8ufAKwoOQLEW0wK/mhLD0mJLV4TBe02CEP32Gbjx1cNp3xViLTW7sq0u0Q==
X-Received: by 2002:a17:906:b847:b0:a42:e2ef:2414 with SMTP id ga7-20020a170906b84700b00a42e2ef2414mr7212089ejb.35.1709056104953;
        Tue, 27 Feb 2024 09:48:24 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id un6-20020a170907cb8600b00a3f0dbdf106sm982577ejc.105.2024.02.27.09.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 09:48:23 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 27 Feb 2024 11:48:17 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 09/20] famfs: Add super_operations
Message-ID: <qfxrbeajea25ckhzx74ieqg7f3baw2pqilliru4djc2a2iii6e@faxw7bgt2vi2>
References: <cover.1708709155.git.john@groves.net>
 <537f836056c141ae093c42b9623d20de919083b1.1708709155.git.john@groves.net>
 <20240226125136.00002e64@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226125136.00002e64@Huawei.com>

On 24/02/26 12:51PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:53 -0600
> John Groves <John@Groves.net> wrote:
> > + */
> > +static int famfs_show_options(
> > +	struct seq_file *m,
> > +	struct dentry   *root)
> Not that familiar with fs code, but this unusual kernel style. I'd go with 
> something more common
> 
> static int famfs_show_options(struct seq_file *m, struct dentry *root)

Actually, xfs does function declarations and prototypes this way, not sure if
it's everywhere. But I like this format because changing one argument usually
doesn't put un-changed args into the diff.

So I may keep this style after all.

John
