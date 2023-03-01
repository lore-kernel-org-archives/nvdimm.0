Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB7510E1
	for <nvdimm@lists.linux.dev>; Wed,  1 Mar 2023 08:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677658656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tLauRQV1B3hnnUPSxsMckjh3y/LZpZ2s1hZ7Yohe9w=;
	b=JlAQjb1MficKkNRbxIR35wz7wrc9JCQbrvul6nmNCEHuvI13maD44SmaAch+EcZD3NGYSz
	ON4bQPhSSZ4U4uekiXwxM9aerT3ICDyma1JDJxTVS374bUxgizNIxs2qagAdPgS9Be48DF
	hdeocgEzR+aW7qpWrEiUxNE1OKe/lDA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-MW7yjL-hMzCLnY_PVtPqlw-1; Wed, 01 Mar 2023 03:17:32 -0500
X-MC-Unique: MW7yjL-hMzCLnY_PVtPqlw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 977E23814581;
	Wed,  1 Mar 2023 08:17:31 +0000 (UTC)
Received: from localhost (ovpn-13-180.pek2.redhat.com [10.72.13.180])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92F7040B40DF;
	Wed,  1 Mar 2023 08:17:29 +0000 (UTC)
Date: Wed, 1 Mar 2023 16:17:25 +0800
From: Baoquan He <bhe@redhat.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>,
	"k-hagio-ab@nec.com" <k-hagio-ab@nec.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
	"ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Subject: Re: [RFC][nvdimm][crash] pmem memmap dump support
Message-ID: <Y/8KFYraba1Lsh5f@MiWiFi-R3L-srv>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
 <Y/4JxQtnmYrZgVwF@MiWiFi-R3L-srv>
 <777f338f-09cb-d9f4-fe5f-3a6f059e4b02@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <777f338f-09cb-d9f4-fe5f-3a6f059e4b02@fujitsu.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 03/01/23 at 06:27am, lizhijian@fujitsu.com wrote:
...... 
> Hi Baoquan
> 
> Greatly appreciate your feedback.
> 
> 
> > 1) In kernel side, export info of pmem meta data;
> > 2) in makedumpfile size, add an option to specify if we want to dump
> >     pmem meta data; An option or in dump level?
> 
> Yes, I'm working on these 2 step.
> 
> > 3) In glue script, detect and warn if pmem data is in pmem and wanted,
> >     and dump target is the same pmem.
> > 
> 
> The 'glue script' means the scirpt like '/usr/bin/kdump.sh' in 2nd kernel? That would be an option,
> Shall we abort this dump if "pmem data is in pmem and wanted, and dump target is the same pmem" ?

Guess you are saying scripts in RHEL/centos/fedora, and yes if I guess
righ. Other distros could have different scripts. For kdump, we need
load kdump kernel/initramfs in advance, then wait to capture any crash.
When we load, we can detect and check whether the environment and
setup is expected. If not, we can warn or error out message to users.
We don't need to do the checking until crash is triggered, then decide
to abort the dump or not.

> > Does this work for you?
> > 
> > Not sure if above items are all do-able. As for parking pmem device
> > till in kdump kernel, I believe intel pmem expert know how to achieve
> > that. If there's no way to park pmem during kdump jumping, case D) is
> > daydream.
> 
> What's "kdump jumping" timing here ?
> A. 1st kernel crashed and jumping to 2nd kernel or
> B. 2nd/kdump kernel do the dump operation.
> 
> In my understanding, dumping application(makedumpfile) in kdump kernel will do the dump operation
> after modules loaded. Does "parking pmem" mean to postpone pmem modules loading until dump
> operation finished ? if so, i think it has the same effect with disabling pmem device in kdump kernel.

I used parking which should be wrong. When crash happened, we currently
only shutdown unrelated CPU and interupt controller, but keep other
devices on-flight. This is why we can preserve the content of crash-ed
kernel's memory. For normal memory device, we reserve small part as
crashkernel to run kdump kernel and dumping, keep the 1st kernel's
memory untouched. For pmem, we may need to do something similar to keep
its content untouched. I am not sure if disabling pmem device is the
thing we need do in kdump kernel, what we want is
1) not shutdown pmem in 1st kernel when crash-ed
2) do not re-initialize pmem, at least do not remove its content

1) has been there with the current handling. We need do something to
guarantee 2)? I don't know pmem well, just personal thought.

