Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EA439A047
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 12:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774267978; cv=none; b=W+KGNh+x+YeiJR96jWUxOpzvOFnIjxf8n//74jzcQkUd5f7iCtlKRNp1kIw15l9DbSkv5VR6A7X2RSE9tyhumJTjD4DlbNCdiXhoTWsF0uRb3cfQDPjhzNCIM9otYRvfNxP3zKA9U/ex4WK27g0hrR8tVc4Pb9G16rv+uVcBYms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774267978; c=relaxed/simple;
	bh=ES47tFda23W0wI6tAmTREEyFeD9xE76p1S65kGx/oNQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NyEzxd0AsftIxWnW2TKS0M4VfXl3AwVAxzB20GB2n1C1zFqPeGR2tZ+AF9FpaulNhSILfScP6YVluwCBJrrzdGFefyrz/3ndnNnW8/QOKPmzy3D1WF0DRaBgKMYHyfjay/+8a1FqlyzJ4cT5+18XadskiE83NOLVHl8SkwF40Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ffX9q6X4NzJ468s;
	Mon, 23 Mar 2026 20:12:47 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F4944056B;
	Mon, 23 Mar 2026 20:12:53 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Mar
 2026 12:12:51 +0000
Date: Mon, 23 Mar 2026 12:12:50 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@groves.net>
CC: Miklos Szeredi <miklos@szeredi.hu>, Dan Williams
	<dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, "Alison
 Schofield" <alison.schofield@intel.com>, John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong"
	<djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Jeff Layton
	<jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, "Stefan Hajnoczi"
	<shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, <venkataravis@micron.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V8 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <20260323121250.00004402@huawei.com>
In-Reply-To: <ab3nFoKxirEgoS_v@groves.net>
References: <20260318202737.4344.dax@groves.net>
	<20260319012837.4443-1-john@groves.net>
	<20260319122057.00004503@huawei.com>
	<ab3nFoKxirEgoS_v@groves.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml500005.china.huawei.com (7.214.145.207)


> > > diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
> > > index 5ed5c39857c8..3bae252fd1bf 100644
> > > --- a/drivers/dax/Makefile
> > > +++ b/drivers/dax/Makefile
> > > @@ -5,10 +5,16 @@ obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
> > >  obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
> > >  obj-$(CONFIG_DEV_DAX_CXL) += dax_cxl.o
> > >  
> > > +# fsdev_dax: fs-dax compatible devdax driver (needs DEV_DAX and FS_DAX)
> > > +ifeq ($(CONFIG_FS_DAX),y)
> > > +obj-$(CONFIG_DEV_DAX) += fsdev_dax.o
> > > +endif  
> > 
> > Why not throw in a new CONFIG_FSDAX_DEV and handle the dependencies
> > in Kconfig?    
> 
> At one point I had another config parameter, but I'm trying not to
> gratuitously add them. The fsdev driver is pretty small, and including it
> whenever FS_DAX is enabled felt reasonable to me. I'm willing to change it
> if there's a consensus that way.

You can make the build do exactly the same thing with a separate Kconfig
option. Just moves where the dependency tracking is. I'd prefer Kconfig
because that's generally where I'd look for something like this.


Jonathan
