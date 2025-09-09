Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681B12701CB;
	Tue,  9 Sep 2025 03:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757387971; cv=none; b=okCxrYAJH6yKjkpOUJAR0kBHKGTSMQuqeQmc0ZICkCq2GteA9+oo/ToCcM73yTu9aa1oWm0QlVEFu3aJ59HF+neqHCYN43LFewVL7tSCvAtc1SJzXnH8Gj7EJPvl+GKXmLq4Kq9RtXQj3OLyin5rM7mAd8KnZv0G1LI3ktTHsIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757387971; c=relaxed/simple;
	bh=dXeL8bHgEJS0WBDFa6oVj6Cg2JQha9x3GSBxLbSsSp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blg+WIfMkmzN0CVwW/+TszlKdRhNgcfIVDW+qbFoFc/FJIenEh+CGszgz5UlSAGEKjiB4ia5vKUHlVdiNvINSwFj0wUY0HmFJCy7Fm/hjE+MGyRlPB8IOMyOenzXK0Q5Ea1h+ooJgZ5wYECh3rKf1E4pzkEt9EgNTeW+TC+lKFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pQ1FQQjo; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pQ1FQQjo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757387961; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kp/49YwOqYc4XSnECrXc1wc8q5JFsR73JTB4gmB0H9s=;
	b=pQ1FQQjoRCYT/XJfjHBsul3f9gzHgN3A4zKiG9UlWO3dgkR4eAfIqgpFJMYKU5viU+f4gX9O9OdJ+5Evxt4DxbE33NLXgOQ2z/wChM1jaWLXuUzUWMTOVHMD/a9knwKKT5rkwm6sJJz51sfrqLC0ru0DZzH6ibF16lIKEN3bnE4=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wnc5f31_1757387957 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 09 Sep 2025 11:19:18 +0800
Message-ID: <2a08292a-fdad-49f1-8ad9-550bf3129b2f@linux.alibaba.com>
Date: Tue, 9 Sep 2025 11:19:16 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] mm/shmem: update shmem to use mmap_prepare
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <2f84230f9087db1c62860c1a03a90416b8d7742e.1757329751.git.lorenzo.stoakes@oracle.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <2f84230f9087db1c62860c1a03a90416b8d7742e.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/9/8 19:10, Lorenzo Stoakes wrote:
> This simply assigns the vm_ops so is easily updated - do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 29e1eb690125..cfc33b99a23a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2950,16 +2950,17 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
>   	return retval;
>   }
>   
> -static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
> +static int shmem_mmap_prepare(struct vm_area_desc *desc)
>   {
> +	struct file *file = desc->file;
>   	struct inode *inode = file_inode(file);
>   
>   	file_accessed(file);
>   	/* This is anonymous shared memory if it is unlinked at the time of mmap */
>   	if (inode->i_nlink)
> -		vma->vm_ops = &shmem_vm_ops;
> +		desc->vm_ops = &shmem_vm_ops;
>   	else
> -		vma->vm_ops = &shmem_anon_vm_ops;
> +		desc->vm_ops = &shmem_anon_vm_ops;
>   	return 0;
>   }
>   
> @@ -5229,7 +5230,7 @@ static const struct address_space_operations shmem_aops = {
>   };
>   
>   static const struct file_operations shmem_file_operations = {
> -	.mmap		= shmem_mmap,
> +	.mmap_prepare	= shmem_mmap_prepare,
>   	.open		= shmem_file_open,
>   	.get_unmapped_area = shmem_get_unmapped_area,
>   #ifdef CONFIG_TMPFS

