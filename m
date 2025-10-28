Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB02533A038
	for <nvdimm@lists.linux.dev>; Tue, 28 Oct 2025 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761664534; cv=none; b=gqzH7SdbCMz87EJWVQYdAacf+W0UqO13SBedi7uAgucQ2N031Lc1AxiNfNcMgzO0WgQtd7kz8DXKqyam4LA8st9G4wAeyn+lns00ZQTu5tr6ltsDZ3ZzgnL8tIghUpdFjyLVal7kTHiJDF4CmbD6EuCT+9DI8G84w9zmchF1tJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761664534; c=relaxed/simple;
	bh=8y5vTKCYkwLQqcy0tF/7ECmndDf2zjapIOdXtmnJ7NM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N676sjbsWXfsC2RvyBxb6XmZUVryzALzyWSs4EQRQeSLF+6TiyNpK4zRvtoqrUku1SQdvOjhmOK7UPL0VVEWC3hVzK81vGNG2GNQC2mtqre8pKZRhIax3GPfoPVXp8QKc5JKO+Osz5dQZ+BrWXYRsi6FdblEfvDIugmL4mbe2Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cwv7s1DvZzJ46Cy;
	Tue, 28 Oct 2025 23:15:21 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 81FBA1402EF;
	Tue, 28 Oct 2025 23:15:29 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 28 Oct
 2025 15:15:28 +0000
Date: Tue, 28 Oct 2025 15:15:27 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <rafael@kernel.org>
Subject: Re: [PATCH v3 2/2] acpi/hmat: Fix lockdep warning for
 hmem_register_resource()
Message-ID: <20251028151527.00004e51@huawei.com>
In-Reply-To: <20251017212105.4069510-3-dave.jiang@intel.com>
References: <20251017212105.4069510-1-dave.jiang@intel.com>
	<20251017212105.4069510-3-dave.jiang@intel.com>
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
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 17 Oct 2025 14:21:05 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> The following lockdep splat was observed while kernel auto-online a CXL
> memory region:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.17.0djtest+ #53 Tainted: G        W
> ------------------------------------------------------
> systemd-udevd/3334 is trying to acquire lock:
> ffffffff90346188 (hmem_resource_lock){+.+.}-{4:4}, at: hmem_register_resource+0x31/0x50
> 
> but task is already holding lock:
> ffffffff90338890 ((node_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x2e/0x70
> 
> which lock already depends on the new lock.
> [..]
> Chain exists of:
>   hmem_resource_lock --> mem_hotplug_lock --> (node_chain).rwsem
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   rlock((node_chain).rwsem);
>                                lock(mem_hotplug_lock);
>                                lock((node_chain).rwsem);
>   lock(hmem_resource_lock);
> 
> The lock ordering can cause potential deadlock. There are instances
> where hmem_resource_lock is taken after (node_chain).rwsem, and vice
> versa.
> 
> Split out the target update section of hmat_register_target() so that
> hmat_callback() only envokes that section instead of attempt to register
> hmem devices that it does not need to.
> 
> Fixes: cf8741ac57ed ("ACPI: NUMA: HMAT: Register "soft reserved" memory as a
> n "hmem" device")
Fix up whatever caused that line to wrap!

> notmuch/

?

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

The guard change seems to be unrelated to rest of the patch.
Probably shouldn't be here.

> 
> ---
> v3:
> - Refactor to split out target device setup vs target update (Dan)
> ---
>  drivers/acpi/numa/hmat.c | 48 ++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
> index 1dc73d20d989..ddbdd32e79a8 100644
> --- a/drivers/acpi/numa/hmat.c
> +++ b/drivers/acpi/numa/hmat.c
> @@ -874,28 +874,10 @@ static void hmat_register_target_devices(struct memory_target *target)
>  	}
>  }
>  
> -static void hmat_register_target(struct memory_target *target)
> +static void hmat_hotplug_target(struct memory_target *target)
>  {

> @@ -906,7 +888,7 @@ static void hmat_register_target(struct memory_target *target)
>  	if (nid == NUMA_NO_NODE || !node_online(nid))
>  		return;
>  
> -	mutex_lock(&target_lock);
> +	guard(mutex)(&target_lock);
Smells unrelated...

If you did want to do this I'd also do
	if (target->registered)
		return;

	hmat_register_target_initiators();
etc.


>  	if (!target->registered) {
>  		hmat_register_target_initiators(target);
>  		hmat_register_target_cache(target);
> @@ -914,7 +896,29 @@ static void hmat_register_target(struct memory_target *target)
>  		hmat_register_target_perf(target, ACCESS_COORDINATE_CPU);
>  		target->registered = true;
>  	}
> -	mutex_unlock(&target_lock);
> +}


