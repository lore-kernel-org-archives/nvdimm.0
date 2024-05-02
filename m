Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EEC57C85
	for <nvdimm@lists.linux.dev>; Thu,  2 May 2024 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714686637; cv=none; b=BoiXboZnaLi2HEwSmvdMVKApPo1o+uXeh7sTIu5SEdbd8z/KE6z5qXxhwSRwesbbsPwFwZfbG2Xv8SIayw0nhMWPrORJNjjHoPpyKsN92L8maGUwn6WyEi+7UjUbr83gKT8MZusdRB81AFSzzMA8/OLeNkpNTf3zPGi29Fip+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714686637; c=relaxed/simple;
	bh=ppkbUoqzUdCyJMzb+MHcpfiSoVPs9MiIWRRGyMb2feg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rV+C2s/+fR7mgErPtWVxMXK/RsoIz+eCEz22/0vdGS1bUqJsvBdwCfC61NNiFkkgavyjGtWAVBBzSoYgJ2F5MnU+kGK2C2imgT4jYD2aLf02+pN27Zcn8DwdB1wICDtLR9LHGOwT/rUpGX8m335rXjRgtwSLrwafusp4Ognk4tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vm+TWbD/; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vm+TWbD/"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5af3cda139fso3851488eaf.1
        for <nvdimm@lists.linux.dev>; Thu, 02 May 2024 14:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714686634; x=1715291434; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49WcWh+p27/ejxTovkH/mAW5dOxEBm4H0Oa3Am0HCjU=;
        b=Vm+TWbD/IleGADpVOP27kcPR3m7CfRePwfRuM7/xSi0g485fpbIhl56i31BffpluuC
         D2AqdSfcglUkZRkAxe3vJW5h5DiSfqtB4cyoT8dUqZIaO4Hz5BIXbBfDw/2MijneXvlM
         Rtxu6eO51EaWWfY/eQ9gv1xjclML/wcGT2TH0uZbywq160LFrLNTMGDVxqcmmHybPfz9
         tPo5BzEVkrBibw016P8mwY4GjNZF6TZ5P+EQY1YD78YH75mDz3RgoUNDVmiVGqKOSBn1
         s0NzIQpKRu0QB8Ljp10gbSLlQEPdWGb+0q9aOsPwYpn40QdPNYTXHgXO2U01mJEQLd45
         8j2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714686634; x=1715291434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=49WcWh+p27/ejxTovkH/mAW5dOxEBm4H0Oa3Am0HCjU=;
        b=WHLNYgC+YW+A0rwF/nKtxpPbCdVn3DkuM5qN4vna/c0+/h/agS1eeIUjhIGRByt3+/
         MPWULwsDs70+y8OHtQk/mC6EWX13J/SXiYEddlm7Yw04sBFVyLoIFIw/jse8NRXM+o4V
         2ObxbTDoDnKTDoixkBlcQMoJf0tj0ikRdcypHpPAye/0S9tbvzpGl4UiH5eHVAADklmk
         mhu40Q+f+Wb/GhLIFTWlqkSrdf4+tjuwPgN/dwWstiVc1gm8cH33c52uZRHCIwBL+uMo
         ZyhWgGSKUUXMqE+lufIRlJ1Zn9aQ+FB0PDls7oSYSIbvD2fgVLfpwySldTvp0vPzQ6wE
         tajA==
X-Forwarded-Encrypted: i=1; AJvYcCV6qap+RDPlwfGHwyBeQbHTbJl5BrDalft9xR64rXRyhUr3DDUi9mH1s9UWTJn2r0OoD6OqOMrucnGcRyYAvttKBvQxT7YS
X-Gm-Message-State: AOJu0YzuQLaB1rCCMupRLz8K+UcjmtVFcNRONDV61+aZ4GIC1W9tPk3M
	LvoEd1X75gzlptgf9QegEFq44PxMch2xqiUQHtNYVxfXemdtrbl0
X-Google-Smtp-Source: AGHT+IF1Ab972Fvtr2pTGuAATvcdTTRtSMOQsbazlcO9vxsi+v5E37xNoBbsZWTP/zprxkgQMcB9tw==
X-Received: by 2002:a4a:aec2:0:b0:5a4:75f2:54d0 with SMTP id v2-20020a4aaec2000000b005a475f254d0mr1188681oon.9.1714686634325;
        Thu, 02 May 2024 14:50:34 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id bx24-20020a4ae918000000b005a4799f5428sm349526oob.21.2024.05.02.14.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 14:50:33 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 2 May 2024 16:50:28 -0500
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
Subject: Re: [RFC PATCH v2 08/12] famfs: module operations & fs_context
Message-ID: <ks3b664olycgyaee3cepaekhaj4qyi2an7cu647xjt2mfwhafn@qzz6ih64zord>
References: <cover.1714409084.git.john@groves.net>
 <86694a1a663ab0b6e8e35c7b187f5ad179103482.1714409084.git.john@groves.net>
 <20240502182354.GH2118490@ZenIV>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502182354.GH2118490@ZenIV>

On 24/05/02 07:23PM, Al Viro wrote:
> On Mon, Apr 29, 2024 at 12:04:24PM -0500, John Groves wrote:
> > +	case S_IFREG:
> > +		inode->i_op = NULL /* famfs_file_inode_operations */;
> > +		inode->i_fop = NULL /* &famfs_file_operations */;
> 
> Don't.  We should never, ever store NULL in either.  
> 	inode->i_op = &empty_iops;
> 	inode->i_fop = &no_open_fops;
> in inode_init_always() is there precisely to avoid doing that.
> 
> IOW, the right thing would be something along the lines of
> 		/* inode->i_op = famfs_file_inode_operations */;
> if you want a placeholder for a patch later in the series - or
> simply /* methods will be set here in a commit or two */

OK, will do - thanks.

John

