Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B47348453
	for <nvdimm@lists.linux.dev>; Sat, 22 Aug 2026 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787372345; cv=none; b=dXNcmxWhOm4mf1Ei8HECm9RaeMNI1/1dK30OusPuQdGVhfaxHAanFoUrUM+w9gs9qJp0ne7omzNAl66vfWVNiGeXMO6CVKioUrW+0fNGk7F0P6g8n6yPx/zFho2Q7DuIuMcBtFBlA+0Rut4lg4lbLqMbZqe2P/X0v1QmvqCE4Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787372345; c=relaxed/simple;
	bh=/Q12GR875iD93KhzcjUTpLysJ1kI3/4TfP0uOO6zmB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/vDUaUWRNJntP25rHHgkHjLhCzEVx8IkmzoiFHzdqSrGcJmEqnWea5nH9Wz3x4glj/4XXme4ARGlA0TeyX9OY/Ew18vjHFq61+1YkSYkZiiJEcU6DDLxYVyR386gOXHTJTjuaKsYGuRffCt3a5Xh+F2oZPSUV+dqImHlq9W4c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=UGk2IGsh; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="UGk2IGsh"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c08df8513so10741731cf.3
        for <nvdimm@lists.linux.dev>; Fri, 21 Aug 2026 21:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787372342; x=1787977142; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bV2EmVqYabp31e4KZo4BjvE2tm+i0eWvAIeJunRO/yE=;
        b=UGk2IGsh6aNjqYQIwuB2OdIXWwfWYB5PGNYx0aWIUagRYwPLIMH+HC+3g+QzCCN+IB
         EYKioTUxXOTFm4SM9gIYqZ6XQSTUIvZ1Xclx56C7rkDEB0EcF1fx4xVhnG9vP6wqw8qt
         uZhEfdxc03uRre2IQyfqlJV/S9s4nnh1UhOE6giHpLnqSrL3Zyi+TgrmzgG5tzRw++04
         93iNd7FITNb6q2CUR8eTl5qIfk3Tgu1SMsHbC0MGSzN1B8OrgBxdMp/lANDjNUXNVd5l
         wK+X+jBt26KH/wSmhp3LP5UBbahYuaR5co7fJ8OoTYEHxKnX2arTCOy+oITwuHdo/4h3
         bDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787372342; x=1787977142;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bV2EmVqYabp31e4KZo4BjvE2tm+i0eWvAIeJunRO/yE=;
        b=I4Yz9irWyIsuT5wH5m6voncWhnSgVMMQSNZhW5Rrw+inkTobCd+Cc1HhnQMr9Oo9qA
         gXYJzdExDR+GuoLSyL5GqfPOoRtfl8Ar9jyVY2jcHNfH3LvAvXRNZ/c5eog/ExhE8QhD
         z1gRs0KynGbbO7ynXCBQx9C4jH10dcx/g2IO/+ohvIvPpPeyBMoCRo4KkKBHCN1V4GxG
         KYtAmVw8z2maeike9NrXnW8intYEXRYMTt71u++x3Aj1jRcQIoSLdWa53pq3S1WBIitZ
         KepZZzWbK5dMI087ksu08UfSM0ak9PFiyeZbWDUe2LTp+DcBbbbihsVS+N67XJo8GZ/P
         pQyw==
X-Forwarded-Encrypted: i=1; AHgh+Ro3V6WTDhvosdUXhy7Y8E2rM03t/EJeIXwI2GCb4ThsCJRx5hO6AStWdGiVmIx5gED2ZCu1Q9Q=@lists.linux.dev
X-Gm-Message-State: AFuF++m5uCtlUy17RnK9dxMGa3ZyUw3GVLPAzwwkXRPy3NauD4YbiRKU
	eo/u62fM8+roRPEDQHhlgQ/wpTZxjuMdHOSxfdRckHlJAeznb66DcfYyMxE+bp2UjvI=
X-Gm-Gg: AR+sD11Pe0YVLSXX3ohn+Ww4S9o0KL3rTFhCt9nkYQMQNeRD/v5jS4EYyEU5Ahcg46T
	HqI/LgHkJGy5lQwYUdNjAJYb6ThY3gCcSyCRcC74ls9NBALHUEoLDycpoLwJK2bGy7yuxNZj1HC
	owjTQcfxJnqvc8NWYqrcyWDnm7vaJSzvYWLJh8AOQ1hxCue4Wg4+e+dLmneP6o6CqOdaPUDsF6U
	ZIdlN63nIZzwcnDnwaN9NooDrZMOMITH8fdLRL43ssZiCdrSRXTXvYF9IVnod9ALuMajG6eWiWC
	QJh1nMdxwp11NvG9Luoib54/PhUVOsFgLgpedq1SlLWxxnlz2VZ/ni5ly6sD9oi3gucq4FoUCTu
	j4w87qaGO+uVhCrGUhecgT7tiJ/coL3bkoJ7kMY0Jw4tJvW+FpvswBg6RHirlG2qv40U1S6w5ua
	zruxn8Q8v6pQIw3Ocfc4KlAkYv3DmPlUTHUq5o4Xsn+8OU+wSqcLUClmf8XnAIHfc5lIDLTVqNp
	qmyuJWRlds49yD1uyvceJ4/yJ574+viYyILX1ZPTgs7
X-Received: by 2002:a05:622a:17c5:b0:52d:a247:bf5f with SMTP id d75a77b69052e-52df5a54f6dmr101297051cf.33.1787372341767;
        Fri, 21 Aug 2026 21:19:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c939314d2sm4857616d6.25.2026.08.21.21.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 21:19:01 -0700 (PDT)
Date: Sat, 22 Aug 2026 00:18:58 -0400
From: Gregory Price <gourry@gourry.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, John Groves <John@groves.net>, 
	Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ira Weiny <iweiny@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Haren Myneni <haren@linux.ibm.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Jiri Slaby <jirislaby@kernel.org>, Ethan Nelson-Moore <enelsonmoore@gmail.com>, 
	Gabriel Whigham <gabewhigham@gmail.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH v13 10/12] famfs: Add runtime operation-permission (opts)
 framework
Message-ID: <aokdSo9li0RtEt35@gourry-fedora-PF4VCD3F>
References: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202539.96378-1-john@jagalactic.com>
 <0100019fed5a5210-a09f1bdb-c705-44fc-8108-a7e7995a7af0-000000@email.amazonses.com>
 <20260822000728.GB6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822000728.GB6047@frogsfrogsfrogs>

On Fri, Aug 21, 2026 at 05:07:28PM -0700, Darrick J. Wong wrote:
> 
> But what prevents a malicious program that is /not/ the famfs client
> software but has CAP_SYS_ADMIN from doing that?
> 

Such a program can already unmount famfs, rebind the device to
device_dax, and mmap the whole range directly. MAP_CREATE isn't
handing it reach it didn't have.

~Gregory
