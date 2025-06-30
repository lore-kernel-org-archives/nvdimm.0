Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22A419A2A3
	for <nvdimm@lists.linux.dev>; Mon, 30 Jun 2025 07:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268539; cv=none; b=qyWLrLiXKxedaWYe+eif6GJGBt5BMInDNsU6xyK50oWfpoSJMXgmnB8lHnIVnbDfiWcwRK7W0VLEY88VPjNSSUxWKycZACo6OjkOrc8IA/xS5ZytY+RVsLhphGCDHmLFic/gExbFWj/zZDMpWD1uIvdKBxCeeXcpBwNnVowGprI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268539; c=relaxed/simple;
	bh=rwYEjU7uadxMKv+kffz8eKea5GinAPI9DlcA8UXayLc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=Kl3WqwfZJkeIVkm+T+AY3s4vgQdqgvNwaVpmEkbtPr/JaZeJ6kAaHYp4caw6ga+sYRhT5wiBAFsWta5N919ZhmPloiwsNe8hef2qeM86djQovwbxBxJga7LS590BpqJXdWUJVm3SgbxS44yd1yxKI2W78u6IFWuF/jAQEpGjPt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=xT72GCmz; arc=none smtp.client-ip=43.163.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="xT72GCmz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1751268515;
	bh=4oV6R0g7aBzIx5O67+BkFEQj9VRZ2iN++AXMTeePqNI=;
	h=From:To:Cc:Subject:Date;
	b=xT72GCmzkzOP4b2Do6Q9vJfbTipjWChgKZRq6lGtIQ/dtVDXGUs/0lvEXr5c3OY0E
	 obagfWQnKPf+25lh7mWLWX+5X6F7RhjVWoW0f82N+oJKaJVaPdndJPtheovkH9Z0LK
	 LPi2Kj2aRvAFm1ti3Vf1f5EJ1vnrY3nIc3YBKYXk=
Received: from NUC10 ([39.156.73.10])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id 7210CE42; Mon, 30 Jun 2025 15:28:33 +0800
X-QQ-mid: xmsmtpt1751268513tih88ih2x
Message-ID: <tencent_9A6812E28AC195905396EEE5A8CAD2ABD306@qq.com>
X-QQ-XMAILINFO: MR/iVh5QLeieg2MZOIDw8BEKxlV6eTl/fCNYe81ERt8FwuJRB2U1qzMxfbCZLH
	 6uLXkJ4phv1la/HPNxshe+uk4hX4xzl+si/p/nOytAe7cfsjt4BkysWXXQv7Kitf8yBkvIAz4gmq
	 JT9dAMZ3+IKkBWf76GMMt5cEP12NPRgA4LpGxpcdNLeL7iCuDN+reJsSZbbTTiUcfNM9fTU1BIER
	 ln6Y8nrn6qDpTJ0AOjlmVY0ZAEXdzgMLo0JBCuWWn7nFv46eAtxvzfu7m5iG+fGXkjBesA9GOdv+
	 tqS3v9wH+PzzgcMQKOwAF2d7JyOIBv7h/CkRKPJwYmdjtENGtGuQN5hyq8ibElWrWHKMYG4pYjf7
	 Vwa7J0UGa3IOocfI1jg7eStT2Zr887fkti9HOG325M86G9zYVEjLspqydJK4gZAHgT+gRVqAiRy8
	 8IsW+fYNHnRVMxDF5d9OddmQ8a0eBk9jOe519Kwu4W3Y006BgJwgBGcqVacq6R0bb9oefL1gYzqx
	 C9yDKWYXW9sUjM4g9ic9Rv0/aoP3yVW6HdOl4W+V6DaP7oowCkNXrFgF9lRpfx5qhK2cpYUb7Wsb
	 YClw4Ar9OfvhlSZraXVU0zCChPYgsSi258SIgcWYd7DAp/9gt+2DppVqTOUrkmxUWuDKZjzg0o49
	 qj8HzxlYkxfFVNL59zRq42wTiVfLZn41+PEESlg5KfG5AoPFO4h93DUAMJUnpnpBDQCsDiTwGUr8
	 4IQJzll0bmiEV/tiGdn83NGKVREc/HhcIh6J6g2yDLwQiU1B9fSYWMeJtxUhmn3pVemQaUU3ej1z
	 saF7MYN5IweHHUlnoU8J/97Vuq3oOYO/8lJmY0bl5NYjExPsLO/so3WOtnxuYBVMkasIrjrV62Hb
	 XdUMUl/ZlzbA7A1137+uEvwcnHDY36GW4fQlwPtmPAbpJ8az8AmSxXTiHO3/XMYH6iDgroqRabs6
	 p5B24cZLRuvoEA/vmrCaTeJlD3dNLqVSaSzqGE7rM=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Rong Tao <rtoax@foxmail.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Rong Tao <rongtao@cestc.cn>
Subject: [ndctl PATCH] Documentation: cxl,daxctl,ndctl add --list-cmds info
Date: Mon, 30 Jun 2025 15:28:25 +0800
X-OQ-MSGID: <20250630072825.313731-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rong Tao <rongtao@cestc.cn>

Such as daxctl(1) manual.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 Documentation/cxl/cxl.txt       | 3 +++
 Documentation/daxctl/daxctl.txt | 3 +++
 Documentation/ndctl/ndctl.txt   | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/Documentation/cxl/cxl.txt b/Documentation/cxl/cxl.txt
index 41a51c7d3892..546207d885eb 100644
--- a/Documentation/cxl/cxl.txt
+++ b/Documentation/cxl/cxl.txt
@@ -14,6 +14,9 @@ SYNOPSIS
 
 OPTIONS
 -------
+--list-cmds::
+  Display all available commands.
+
 -v::
 --version::
   Display the version of the 'cxl' utility.
diff --git a/Documentation/daxctl/daxctl.txt b/Documentation/daxctl/daxctl.txt
index f81b161c9771..606abc3e9635 100644
--- a/Documentation/daxctl/daxctl.txt
+++ b/Documentation/daxctl/daxctl.txt
@@ -14,6 +14,9 @@ SYNOPSIS
 
 OPTIONS
 -------
+--list-cmds::
+  Display all available commands.
+
 -v::
 --version::
   Display daxctl version.
diff --git a/Documentation/ndctl/ndctl.txt b/Documentation/ndctl/ndctl.txt
index c2919de4692d..08c3e949418a 100644
--- a/Documentation/ndctl/ndctl.txt
+++ b/Documentation/ndctl/ndctl.txt
@@ -14,6 +14,9 @@ SYNOPSIS
 
 OPTIONS
 -------
+--list-cmds::
+  Display all available commands.
+
 -v::
 --version::
   Display ndctl version.
-- 
2.50.0

