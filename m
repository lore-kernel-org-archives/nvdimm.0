Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA94401485
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364037; cv=none; b=oTwmWYGATPjXUvVJ7TrWa9D2B+xvVzEtX6v4igATL8FmwkHmC4PhoBRn26W5s6rGg03VRINZPW3x3uISvFSTFhTz76VUd/saY9nu48J9a2HNzsnxLTRjsLbHVCbhIe4hMphf2mqCTe5fTyBDqFEq8G5P9gCMmseUkxPTe3nGYmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364037; c=relaxed/simple;
	bh=izN5BqXH7ypvzKY+zoIDfa3X5OW6W7M/6WfX2y/Wo+4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FIHXsKoBHiMy/azgjyZP30rTZlgpkA11xw2oUxEVGcwoKyuuEm/9/FxBRdwcSOVCfe0tQJD/2F5SgF8os8H6uFwnVYpfM1UJn2su41jRutYf4ow3JY8MDTbpBPgDlhAMQIc8sgjSZQPnp9ta91P45cJh6RSC4eTOO3ZYFjqofYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgChZ6rjszHnGk0;
	Tue, 24 Mar 2026 22:53:18 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 76B2F4058B;
	Tue, 24 Mar 2026 22:53:52 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 14:53:50 +0000
Date: Tue, 24 Mar 2026 14:53:49 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@Groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>, John Groves
	<jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, "David
 Hildenbrand" <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan
 Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef
 Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen
 Linxuan <chenlinxuan@uniontech.com>, "James Morse" <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>, "Sean Christopherson" <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay
 Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 6/8] dax: Add dax_set_ops() for setting
 dax_operations at bind time
Message-ID: <20260324145349.00002317@huawei.com>
In-Reply-To: <0100019d1d4814db-1e36cd9c-09c3-4e60-b48f-2b5c3cb9e406-000000@email.amazonses.com>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
	<20260324003906.5083-1-john@jagalactic.com>
	<0100019d1d4814db-1e36cd9c-09c3-4e60-b48f-2b5c3cb9e406-000000@email.amazonses.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 24 Mar 2026 00:39:16 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <John@Groves.net>
> 
> Add a new dax_set_ops() function that allows drivers to set the
> dax_operations after the dax_device has been allocated. This is needed
> for fsdev_dax where the operations need to be set during probe and
> cleared during unbind.
> 
> The fsdev driver uses devm_add_action_or_reset() for cleanup consistency,
> avoiding the complexity of mixing devm-managed resources with manual
> cleanup in a remove() callback. This ensures cleanup happens automatically
> in the correct reverse order when the device is unbound.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


