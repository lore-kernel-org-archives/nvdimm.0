Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C1517FEE
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 15:24:52 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6439b410679so3752271b3a.0
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 08:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683645892; x=1686237892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vyr+apyl4rf0JIzVOh3eQ3ozl2SeH9P0a8gHOxOKkIs=;
        b=jH+ZIQdAHDND6cvO/qCI04ZDNBlOTIXP5ufUkp/H2r8JTB95muW+mvfmPxAq+J3g1n
         G8u7Y48aBPQPezNhg5fsCMXtqRg5nUPf6tUcvYj2kRR54Ny4zzhTZ8MM0s8DYL0ry//A
         1dP3baRphA7Yb5tXIjHDy3l56xalgio9oCuzLVewc/FvsfbRC6GVLrda9cvKFxX+kR3E
         Rklhzr8LjnNhOVhFv2jgNOx/Zi7hsqrm5Jbfs08fYRsOOiLfE1zRH1Y7y+KAwhH6teJ5
         g6iQ5FA42x10lYwY3h0T1qUuRnUKHjpl7egIjM1eAZ2QqFRSOhbKZb4LpI+DSEQB1TOj
         v6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645892; x=1686237892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vyr+apyl4rf0JIzVOh3eQ3ozl2SeH9P0a8gHOxOKkIs=;
        b=Psejg4Q9QtzTgQaV21NP6ZINb74Nk9FNkOPW1Tj6/bSzQoaVNiQLszf4DAUC78kitQ
         gsLCvuCZ6HZyg8658CzuheirdBkCAXmUfgEnBDTqXwFuh6I0oIOnRHgRp0BQFJxFbfNe
         QafEyz1qwZs60qJy27ZjcYFjEn8KS8/Bo04wXjF9T2bGvz3AmarSDG0UJndUYe1yGZsV
         h/G/tOrWo4QAXr79pnveadb/RMD4gNlgH+5T0Ze0z3rL0sLjy0LoXxWOzYz0f9Z57NDM
         k5lLu+6ml587lPwAInwsM3SJcaJaAbu5SzP7F4d2STSklDPWzEBWl+d4jfvI4/ul6I06
         gtww==
X-Gm-Message-State: AC+VfDzK0aOnBc8JIRL0PAqpKO66qxcQVHcHtxHhyAKqS1m4Pp5GARdV
	FLRmo1sZpyF/p2hcjM0AiSM=
X-Google-Smtp-Source: ACHHUZ4OLUMIpz/C9s5AvMa2qC8uAizriCj+aiq/qyh9FUJg+ndTLjWXS291fjHOp+/jIvPRL7BF1w==
X-Received: by 2002:a05:6a00:16c4:b0:643:9dcd:abba with SMTP id l4-20020a056a0016c400b006439dcdabbamr21619366pfc.29.1683645891703;
        Tue, 09 May 2023 08:24:51 -0700 (PDT)
Received: from localhost ([1.230.133.98])
        by smtp.gmail.com with ESMTPSA id s4-20020a62e704000000b006414b2c9efasm1894351pfh.123.2023.05.09.08.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:24:51 -0700 (PDT)
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [ndctl PATCH 1/3] cxl/list: Fix typo in cxl-list documentation
Date: Wed, 10 May 2023 00:24:25 +0900
Message-Id: <20230509152427.6920-2-minwoo.im.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
References: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

s/the returned the returned object/the returned object
s/ellided/elided
s/hierararchy/hierarchy
s/specifed/specified
s/identidier/identifier
s/scenerios/scenarios

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
---
 Documentation/cxl/cxl-list.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index c64d65d3ffbe..838de4086678 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -18,9 +18,9 @@ instances along with some of their major attributes.
 Options can be specified to limit the output to specific objects. When a
 single object type is specified the return json object is an array of
 just those objects, when multiple objects types are specified the
-returned the returned object may be an array of arrays with the inner
-array named for the given object type. The top-level arrays are ellided
-when the objects can nest under a higher object-type in the hierararchy.
+returned object may be an array of arrays with the inner
+array named for the given object type. The top-level arrays are elided
+when the objects can nest under a higher object-type in the hierarchy.
 The potential top-level array names and their nesting properties are:
 
 "anon memdevs":: (disabled memory devices) do not nest
@@ -34,7 +34,7 @@ The potential top-level array names and their nesting properties are:
 "endpoint decoders":: nest under endpoints, or ports (if endpoints are
    not emitted) or buses (if endpoints and ports are not emitted)
 
-Filters can by specifed as either a single identidier, a space separated
+Filters can be specified as either a single identifier, a space separated
 quoted string, or a comma separated list. When multiple filter
 identifiers are specified within a filter string, like "-m
 mem0,mem1,mem2", they are combined as an 'OR' filter.  When multiple
@@ -263,7 +263,7 @@ OPTIONS
 --buses::
 	Include 'bus' / CXL root object(s) in the listing. Typically, on ACPI
 	systems the bus object is a singleton associated with the ACPI0017
-	device, but there are test scenerios where there may be multiple CXL
+	device, but there are test scenarios where there may be multiple CXL
 	memory hierarchies.
 ----
 # cxl list -B
-- 
2.34.1

