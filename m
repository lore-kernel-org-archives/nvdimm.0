Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAD226D4C3
	for <nvdimm@lists.linux.dev>; Sun, 23 Aug 2026 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787503401; cv=none; b=SCQf+9DJclxznLsWMWWol5IlXYNTvNpbwTB7t8Ehh6AVzw9P0FJteV8r0fb3rRqPREZMBPIWnsbnoDAEojL2bfrhGuDpqdkkgyzIGAoRWsfpVNcBml9XnaC8iV6qdPhaTDEmP0/UUIXQpDQ/Ia4by1UKQaUpdBOgm9z1UyY9f2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787503401; c=relaxed/simple;
	bh=pWDzkQYpINPFTZeR8thS8nOa7PK6nZSbqUQipGA4xXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXjpRPBZf5UTb4MIb0bGkP7lLIOXQvx0H6977tfO7kuMEEZsatKgZS8yIxYxRYoxPXhP5WFsh8AOt0REwflp4UsdnGlleC0aGIgGszZ7Iaq7qKb/pxFJowhl6DuU1qc0ViSaqJNnRaNYBX7A3a6C0Lf9UWl4IrTlTXNCbJ1bNfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RfPa5BS8; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RfPa5BS8"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c2cce930cso27635861cf.0
        for <nvdimm@lists.linux.dev>; Sun, 23 Aug 2026 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787503398; x=1788108198; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4EA5wtk151L22kFWX4iHeihngZ8TcErsEBYYtEmRpXE=;
        b=RfPa5BS8XhRybp1IDjoYulhXRkG1YcI3Q2VvCI6h2+3bDksKIaAm50jtSADOnbQeDn
         0Tn+YdJ7UcpcRlncEV8NTd0SnXy3v0ETPxturmda95MwTbJ5sJxD9tfLJiPO9kIqkevZ
         u4PtcVeQeeyEb/qfuIvM8bSzBW4A/gGX6V7YaM13yG1Vq2ck0K65P5uu30cqKVIvs49k
         G2AZ4cIKYDwIAk0XqmpqPL0JjsRFhtlmftVvXQCwSYYv/ad96h9YSwQd9udbCgjbKvh6
         hx5Y+PVmYlVZqgPi+GdXlDstYSRQrEa1XkGM6TRaxH95J4NEx2fuZOsumpWzJ/Y5SIDO
         30cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787503398; x=1788108198;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EA5wtk151L22kFWX4iHeihngZ8TcErsEBYYtEmRpXE=;
        b=epKxLSuAcSHsoW938Z6oGxyzyZZ40a+fIIQpRWtc9n5+NgEBSVhiCJVXmNvhSuci4A
         M0HEEPNDvfJ8PQTRje/VAOoHqW9Kk/Zb7y/vwPN4pN3bUhB957mIgjOdf/Y6fdRkSmdc
         WsJs7dH4Gti/hH6cqwNWbfS25TiMVnb1yfXQBymiJ/kAjJs43zCQL8oWguacs50zpBlP
         AV327mn5+IykLHnnmVtD7Cb3zi+q1AUkNBLtbOCbjesE+bh2Ij/Hpgu2L6k3/3/q188m
         hOznjy61FUmF5wf3RwYKv1vp05PEzCMd3VIk4MncoxXnxyEixn1Mihkii+a1WYpNI39Q
         WkLA==
X-Forwarded-Encrypted: i=1; AHgh+Ro3zk2PPxhfpA/YwnJ+MU9xqcm2gOapZyElEjHzOE9/LWes6z//yG7ScGwg3s4veiVKZmVxGo4=@lists.linux.dev
X-Gm-Message-State: AFuF++kvjaMQfBPZjssIr8GoNSkR4umKvUMwcb0gEAt3/3yeJbMNTs51
	IoZV37SOgkNbeAQk9zyRvwKSDykrdqleTkmBvMXYr6p8mjAJ2nr7NjUC+uSsMKz8Xwc=
X-Gm-Gg: AR+sD112q4Y2q+9w6uPMf6w6TameUSECSX6TATka10vrkKBjIQdG1xnf66RLpoPrK8K
	PKBz5lGn8in0pbC8ZtH5y3KZOYzJ0iRnS8zx6LTw5YL/phCBwfOwTOSfID4Lx0I1mL3+Ad8nqAx
	udDs/uo5PnD4VJXBnvj3Ds/wU+EzHfaKGjD+QnaVvYIQhs/QzxZgOZjkCDBgkrfU+LJ9zHM2uNz
	7Oxr1uUo5qT6pJSxVUHeQUFrLFiAf7MXPNo6fOPXG0kQQTf45V1l/f6/Ki2Ylas2HLa/MxXAe2p
	vf7KmkVdhH1c0Kx53JaDf/WJ6UrP+YKH0HjD7ES9B/XnTqIAJoJ2h7vIF/jyE3eq8N7rLz2gvGz
	a2oaASTD5oCB/R5wuuHPHZuElGiP6LRHDONGRbCxr5m27KdUNjmI13nn24OpiEldwHbdGact7ko
	xU1o+IUaPTpnqDeVl4bzH6sPogc7i/5tz+LPP7t2+DQCKHELQPke0MKTlo/b7WKDc92HU6uysxn
	dXSdWpU28xMi7ZhGGizZK1i60c+Mib3oABglgn6yk+xUZvlFER2gCc=
X-Received: by 2002:a05:622a:90e:b0:51c:1fd1:e755 with SMTP id d75a77b69052e-52df59e7e7amr219365661cf.36.1787503398278;
        Sun, 23 Aug 2026 09:43:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c9361720bsm41074616d6.21.2026.08.23.09.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 09:43:17 -0700 (PDT)
Date: Sun, 23 Aug 2026 12:43:14 -0400
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
Message-ID: <aosejKmNJxCIpQho@gourry-fedora-PF4VCD3F>
References: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202539.96378-1-john@jagalactic.com>
 <0100019fed5a5210-a09f1bdb-c705-44fc-8108-a7e7995a7af0-000000@email.amazonses.com>
 <20260822000728.GB6047@frogsfrogsfrogs>
 <aokdSo9li0RtEt35@gourry-fedora-PF4VCD3F>
 <20260822174029.GC6110@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822174029.GC6110@frogsfrogsfrogs>

On Sat, Aug 22, 2026 at 10:40:29AM -0700, Darrick J. Wong wrote:
> 
> A bigger question I just thought of is sharing cxlmem between files (aka
> reflink).  Is that allowed?  I could see a theoretical usecase for
> programs A and B wanting to share some cxlmem for communication or
> heartbeats whilst having their own /a and /b files for their private
> memory.  Probably you'd just create a /common file to do that and not
> map the same cxlmem page into /a and /b, right?
> 

If the underlying memory hardware is hardware-coherent, then this would
be supportable because the coherence domains of all the hosts connected
to the large pool would extend to one another.

In our current world, these huge-memory distributed memory systems are
non-coherent and each host's coherence domain stops more or less at the
head it uses to connect to the shared media (it's probably more accurate
to say it's "device dependant" but that's besides the point).

Anyway, there's "allowed" and "useful".  You could technically do it
(maybe not with FAMFS' current guard rails) - but it would be useless
unless Process A and Process B were in the same coherence domain.

~Gregory
