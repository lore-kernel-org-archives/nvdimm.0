Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31F546BF;
	Sat, 21 Mar 2026 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774114823; cv=none; b=ScM/0q5e/fGfTSATqbitkgRlG/hXA3PVbDYawZ2TkqeNQ8XDsfBXs7ezF6pADIbQTgRf72AFw7dLWhCbsDAqwAiVxBQX7NjN4n+Kikv6GjXqRaC1/xfsrZGeUAY2gZ4SOQh/yJf0ZsezDSm4HcGk4Br9fIXJ3XEqXJRHmyzietI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774114823; c=relaxed/simple;
	bh=Ls3i/3Z4Mf14P1cnWkjQU7GQ+uXpXitTAoEU6mU1e/8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=D44+8IwqMXsxK/64EFL3+6YS428KFZJRK0AAK/hY3W5YfUeG8SXdCTIC4xvs2UhMqweA1wgzpf1g6ByMla05bCZhj+tbhYJjiFRfSTsYWsTK1IucekxrRrQpSzo8maqoIpfH1jEEojqJQroGi8CY1bzhyr4B8O539C5XN/yAmZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S+pDJMhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S+pDJMhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931AEC19421;
	Sat, 21 Mar 2026 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774114823;
	bh=Ls3i/3Z4Mf14P1cnWkjQU7GQ+uXpXitTAoEU6mU1e/8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S+pDJMhXziAJr/dUnXYVT+7qiwwywkY5CGkhjVrlnbONIgUSo6UIBB7n874AHlQgI
	 CrlPMffuYtVHmc5Fdunv3viqL9xchhv9+KmM+9nGgzzWm/SCmvIzIaYr2r+CsTAGq4
	 HBupKmHMUR3DAXVWOqHmJK8HYr8SL4TqUUmWpKzY=
Date: Sat, 21 Mar 2026 10:40:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 david@kernel.org, osalvador@suse.de, dan.j.williams@intel.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-Id: <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 21 Mar 2026 11:03:56 -0400 Gregory Price <gourry@gourry.net> wrote:

> The dax kmem driver currently onlines memory during probe using the
> system default policy, with no way to control or query the region state
> at runtime - other than by inspecting the state of individual blocks.
> 
> Offlining and removing an entire region requires operating on individual
> memory blocks, creating race conditions where external entities can
> interfere between the offline and remove steps.
> 
> The problem was discussed specifically in the LPC2025 device memory
> sessions - https://lpc.events/event/19/contributions/2016/ - where
> it was discussed how the non-atomic interface for dax hotplug is causing
> issues in some distributions which have competing userland controllers
> that interfere with each other.
> 
> This series adds a sysfs "hotplug" attribute for atomic whole-device
> hotplug control, along with the mm and dax plumbing to support it.

AI review (which hasn't completed at this time) has a lot to say:
	https://sashiko.dev/#/patchset/20260321150404.3288786-1-gourry@gourry.net
