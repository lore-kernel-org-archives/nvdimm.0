Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF1057C85
	for <nvdimm@lists.linux.dev>; Thu,  2 May 2024 21:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714686692; cv=none; b=vGUz/TVbq9ynctqKBHO2YA0PBuqUaVxXGo3z2N6ibHoJBjJoVjkLaI2WEwAZoJZOzsSK36qzlMZPci46V+qVEarDaRd93pOhCJ+O/MezfrLFVJHGN8zS/kKONljKeX+UsrIfReCmqbr/almM2XkP9dl0yHahqZP4T0upEf+ZFoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714686692; c=relaxed/simple;
	bh=S79CR/D0QfH8x8Go5DBVB2FXN5RusN1WZY8uz7rbrbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3UGciupB9MOACbNXfhkQ2BQaSBjuB/xKhS81Hp3C+Lvhd8uoZOEX6MQdrCCXenClxqPnTN0/5fGpfPU5koJt+2ewW4JZ02Yj5vcZokeBbRj9e7gozRtj6yqQwi75BYcR5mk5YLSeK4tyxMHQj6Bp54Ch7GwUDp8AcypnSZX9Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mb1OLdSe; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mb1OLdSe"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ed3587b93bso5038506a34.1
        for <nvdimm@lists.linux.dev>; Thu, 02 May 2024 14:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714686690; x=1715291490; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/L7A7dIowev4LaiY/g2BbviZcRIkjSV7hdCjyGrk3HQ=;
        b=mb1OLdSe8zYLXODD/wW062WA1asRv2FNWMrbbwYbfUKj4TN+a2yDVaGXf83G21F8Z/
         HCnCSTXWD2gaBsMdEdigHJTeAEHz51bB0a8Ofwx2USF9zTXQpbzth7Yi6GwV3cVMAGEs
         CyAubWotr4ztG1XGWI70IWjvTV0toXW8rWrGHmohcY9Hrape83Xg6x9Pad4qdEAUvxBW
         FDzp9950jwtV8zFiF7NaTSSZyRzBo40xm2RkGmJU2P1qFNWW0lq5OIxMM3j9N1mHqRRm
         qHTItOXaqQjrIKat1WCEauA722LjdJ9QXGSpVOj5lWrhviOgkdK85oVXr0+lZnErzUht
         +tKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714686690; x=1715291490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/L7A7dIowev4LaiY/g2BbviZcRIkjSV7hdCjyGrk3HQ=;
        b=ezR9SjBNG1X988olVpOzRMg/hKsG8Fus3l0XyTVPSuUaWud3xFAgDLBYwBugvif4ar
         DVWIdqb2tAutciMrKTB8zjZ5GkaGT3an61mbejYYpP6sHsqyHSm5vM+0GNlfCHumw+37
         QXDebkHuaf4wLxnJJBMvGBJ37LIYEehUvmvQOkfEYklznVP/AFMcMDLARht7iVs5O8W6
         HwOeEp9MaLIs3JZEqOX2NkbGDG5K4c8PQZcHLhVR5/qONeIaPtRWfJtDygvt/CzLFztE
         LQ4WKbVI5fizZy7uumQlUEDqYeKGRru9gsiXMQCZ4fMMBG4Cu3AyBLAwc5EK62rJlNLX
         FrMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1vUX22dwWmQBy4nMJP5w5siCPoAO+5Na0k8N+mZyGtuCodyYC8tmo4pIeYG6OwFhaYz0zSJCMkZuFIlmBpvPsiSKPZzmN
X-Gm-Message-State: AOJu0YyR4EDBaVZhVAyqoFB65i+8R+dWtb1hGtvWymt4t/SmzGUTMYMr
	5ZXWnuaUXT9CHCUgpHWB6hEeZQXb3/zSHPlL1nOQR3jcc+Q3EVnF
X-Google-Smtp-Source: AGHT+IFFgIbdiVUhYAit9UXZMJJnEDO4/rfUMvDDA2e98Nw+Grxi47KMDAzShlYWDx3bPLusPCrlAw==
X-Received: by 2002:a05:6830:3493:b0:6ee:35a4:1583 with SMTP id c19-20020a056830349300b006ee35a41583mr1643807otu.30.1714686690447;
        Thu, 02 May 2024 14:51:30 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id f11-20020a056830264b00b006ea19aa0e4fsm357999otu.29.2024.05.02.14.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 14:51:29 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 2 May 2024 16:51:27 -0500
From: John Groves <John@groves.net>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	John Groves <jgroves@micron.com>, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com, 
	Randy Dunlap <rdunlap@infradead.org>, Jerome Glisse <jglisse@google.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Eishan Mirakhur <emirakhur@micron.com>, Ravi Shankar <venkataravis@micron.com>, 
	Srinivasulu Thanneeru <sthanneeru@micron.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Chandan Babu R <chandanbabu@kernel.org>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Steve French <stfrench@microsoft.com>, 
	Nathan Lynch <nathanl@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Julien Panis <jpanis@baylibre.com>, 
	Stanislav Fomichev <sdf@google.com>, Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [RFC PATCH v2 10/12] famfs: Introduce file_operations read/write
Message-ID: <v2lja6m6hzod4iuhvhzdtu35o6xy7pf4oloq6qeck2k6ohbpn6@fsxygfwvxo5b>
References: <cover.1714409084.git.john@groves.net>
 <4584f1e26802af540a60eadb70f42c6ac5fe4679.1714409084.git.john@groves.net>
 <20240502182919.GI2118490@ZenIV>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502182919.GI2118490@ZenIV>

On 24/05/02 07:29PM, Al Viro wrote:
> On Mon, Apr 29, 2024 at 12:04:26PM -0500, John Groves wrote:
> > +const struct file_operations famfs_file_operations = {
> > +	.owner             = THIS_MODULE,
> 
> Not needed, unless you are planning something really weird
> (using it for misc device, etc.)

Got it - thanks!

John

