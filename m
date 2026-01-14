Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEED3815DB;
	Wed, 14 Jan 2026 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768385667; cv=none; b=SkLr9UnyRcBric+I3alYyFoPLlr8oQV+9KRwOlf2/vsGMZtlqjdshmR+C5/zUGCpoAyNR2XgTJXRlRA3ZlXFH1aYviSKj6kCwNsOifauj6EmdyMqrGPGm9MoiWT87MqzfwRj1EQ6JOMD2ebx8OE0WNazDBXzRUZhy2IwiGzz9ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768385667; c=relaxed/simple;
	bh=jRidKOsmBV2qAukpkzJ1Z7JnB+sebWyAj38kbIeO6OY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THUS+YGBAcafTLbHvxfiP6EQ0Ajle+ibyqSjKbeioaWx6Ahw7xodJzoPK5aS+SanTGfVRartMv9NErbzbCgc6iLb67VpcYqnwPfaJZVBWSUVyo4EgwyZ3pBaBv32jj2FUhM7v3SbqhYYVbeoIoa35F1wKm8dVn6AqLSaBVZWVA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ4zbdQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ4zbdQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ABFC4CEF7;
	Wed, 14 Jan 2026 10:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768385666;
	bh=jRidKOsmBV2qAukpkzJ1Z7JnB+sebWyAj38kbIeO6OY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RZ4zbdQd5Y9j899jDtFhUSkFbbgJE06nr6NyLRWaAR2A79x1gC88cDHXW2q4S3wPq
	 MS34HZSb4I/tbInqH7V+S6NjODGXeRVgPEhLVfR/YU5K5g50qUA+kG1+OQXvw348lC
	 z+ZOTbDLTh/xSYMHwc7XOOgdBChFu/CgB9wzgvAg/PkbeMHdDArjRX6R3DhH7bb4rz
	 6MO54LTUuVqxATcfedHnBndnq+n6hRQ89WDH5rZy3wGQE0Xo25KvItgAjftg9V6Ajy
	 k+oc3ucRRa/qieJJdt03HMDmM1Ro8yvGQTOV7RBnzHyL0XowmUthP4d6iSRwxotf7f
	 XeFj+QU1pNCRA==
Message-ID: <c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org>
Date: Wed, 14 Jan 2026 11:14:21 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm/memory_hotplug: extract __add_memory_resource()
 and __offline_memory()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-3-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114085201.3222597-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 09:51, Gregory Price wrote:
> Extract internal helper functions with explicit parameters to prepare
> for adding new APIs that allow explicit online type control:
> 
>    - __add_memory_resource(): accepts an explicit online_type parameter.
>      Add MMOP_SYSTEM_DEFAULT as a new value that instructs the function
>      to use mhp_get_default_online_type() for the actual online type.
>      The existing add_memory_resource() becomes a thin wrapper that
>      passes MMOP_SYSTEM_DEFAULT to preserve existing behavior.
> 
>    - __offline_memory(): extracted from offline_and_remove_memory() to
>      handle the offline operation with rollback support. The caller
>      now handles locking and the remove step separately.


I don't understand why this change is even part of this patch, can you 
elaborate? You don't add any "explicit parameters to prepare for adding 
new APIs that allow explicit online type control" there.

So likely you squeezed two independent things into a single patch? :)

Likely you should pair the __add_memory_resource() change with the 
add_memory_driver_managed() changed and vice versa.

> 
> This refactoring enables future callers to specify explicit online
> types (MMOP_OFFLINE, MMOP_ONLINE, MMOP_ONLINE_MOVABLE) or use
> MMOP_SYSTEM_DEFAULT for the system default policy. The offline logic
> can also be used independently of the remove step.
> 
> Mild functional change: if try_remove_memory() failed after successfully
> offlining, we would re-online the memory.  We no longer do this, and in
> practice removal doesn't fail if offline succeeds.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   include/linux/memory_hotplug.h |  2 +
>   mm/memory_hotplug.c            | 69 ++++++++++++++++++++++------------
>   2 files changed, 48 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index f2f16cdd73ee..d5407264d72a 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -29,6 +29,8 @@ enum {
>   	MMOP_ONLINE_KERNEL,
>   	/* Online the memory to ZONE_MOVABLE. */
>   	MMOP_ONLINE_MOVABLE,
> +	/* Use system default online type from mhp_get_default_online_type(). */
> +	MMOP_SYSTEM_DEFAULT,

I don't like having fake options as part of this interface.

Why can't we let selected users use mhp_get_default_online_type() 
instead? Like add_memory_resource(). We can export that function.


-- 
Cheers

David
