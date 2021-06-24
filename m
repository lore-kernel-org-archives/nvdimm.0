Received: from ozlabs.org (ozlabs.org [203.11.71.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF40E2FB3
	for <nvdimm@lists.linux.dev>; Thu, 24 Jun 2021 03:17:22 +0000 (UTC)
Received: by ozlabs.org (Postfix, from userid 1007)
	id 4G9QKr2CyHz9sXk; Thu, 24 Jun 2021 13:17:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=gibson.dropbear.id.au; s=201602; t=1624504640;
	bh=NbTQbQQ9qUR8H6RYZM+xj6EmkL92kbgF241vaPjjXzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GDBf8OX5/51o0uCJtIyz0soti6TOegytzwhnFCKDDs7FsWVyqoe+PoVzjuCGmU2Cs
	 WvOy2trBX/S5fermbXuJLtmkTPW+YaxnZa2uShAuhwBYOUnynZTFqz3GRZfXarroPE
	 IcMP88oQFyoqb6A/8t3IyrTLwmOTocCcC2wfT8ig=
Date: Thu, 24 Jun 2021 11:46:02 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH v4 1/7] powerpc/pseries: rename min_common_depth to
 primary_domain_index
Message-ID: <YNPj2tM3Nu7HwLDm@yekko>
References: <20210617165105.574178-1-aneesh.kumar@linux.ibm.com>
 <20210617165105.574178-2-aneesh.kumar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LRFf1+pJXygmf9bq"
Content-Disposition: inline
In-Reply-To: <20210617165105.574178-2-aneesh.kumar@linux.ibm.com>


--LRFf1+pJXygmf9bq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 17, 2021 at 10:20:59PM +0530, Aneesh Kumar K.V wrote:
> No functional change in this patch.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  arch/powerpc/mm/numa.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
>=20
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index f2bf98bdcea2..8365b298ec48 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -51,7 +51,7 @@ EXPORT_SYMBOL(numa_cpu_lookup_table);
>  EXPORT_SYMBOL(node_to_cpumask_map);
>  EXPORT_SYMBOL(node_data);
> =20
> -static int min_common_depth;
> +static int primary_domain_index;
>  static int n_mem_addr_cells, n_mem_size_cells;
>  static int form1_affinity;
> =20
> @@ -232,8 +232,8 @@ static int associativity_to_nid(const __be32 *associa=
tivity)
>  	if (!numa_enabled)
>  		goto out;
> =20
> -	if (of_read_number(associativity, 1) >=3D min_common_depth)
> -		nid =3D of_read_number(&associativity[min_common_depth], 1);
> +	if (of_read_number(associativity, 1) >=3D primary_domain_index)
> +		nid =3D of_read_number(&associativity[primary_domain_index], 1);
> =20
>  	/* POWER4 LPAR uses 0xffff as invalid node */
>  	if (nid =3D=3D 0xffff || nid >=3D nr_node_ids)
> @@ -284,9 +284,9 @@ int of_node_to_nid(struct device_node *device)
>  }
>  EXPORT_SYMBOL(of_node_to_nid);
> =20
> -static int __init find_min_common_depth(void)
> +static int __init find_primary_domain_index(void)
>  {
> -	int depth;
> +	int index;
>  	struct device_node *root;
> =20
>  	if (firmware_has_feature(FW_FEATURE_OPAL))
> @@ -326,7 +326,7 @@ static int __init find_min_common_depth(void)
>  	}
> =20
>  	if (form1_affinity) {
> -		depth =3D of_read_number(distance_ref_points, 1);
> +		index =3D of_read_number(distance_ref_points, 1);
>  	} else {
>  		if (distance_ref_points_depth < 2) {
>  			printk(KERN_WARNING "NUMA: "
> @@ -334,7 +334,7 @@ static int __init find_min_common_depth(void)
>  			goto err;
>  		}
> =20
> -		depth =3D of_read_number(&distance_ref_points[1], 1);
> +		index =3D of_read_number(&distance_ref_points[1], 1);
>  	}
> =20
>  	/*
> @@ -348,7 +348,7 @@ static int __init find_min_common_depth(void)
>  	}
> =20
>  	of_node_put(root);
> -	return depth;
> +	return index;
> =20
>  err:
>  	of_node_put(root);
> @@ -437,16 +437,16 @@ int of_drconf_to_nid_single(struct drmem_lmb *lmb)
>  	int nid =3D default_nid;
>  	int rc, index;
> =20
> -	if ((min_common_depth < 0) || !numa_enabled)
> +	if ((primary_domain_index < 0) || !numa_enabled)
>  		return default_nid;
> =20
>  	rc =3D of_get_assoc_arrays(&aa);
>  	if (rc)
>  		return default_nid;
> =20
> -	if (min_common_depth <=3D aa.array_sz &&
> +	if (primary_domain_index <=3D aa.array_sz &&
>  	    !(lmb->flags & DRCONF_MEM_AI_INVALID) && lmb->aa_index < aa.n_array=
s) {
> -		index =3D lmb->aa_index * aa.array_sz + min_common_depth - 1;
> +		index =3D lmb->aa_index * aa.array_sz + primary_domain_index - 1;
>  		nid =3D of_read_number(&aa.arrays[index], 1);
> =20
>  		if (nid =3D=3D 0xffff || nid >=3D nr_node_ids)
> @@ -708,18 +708,18 @@ static int __init parse_numa_properties(void)
>  		return -1;
>  	}
> =20
> -	min_common_depth =3D find_min_common_depth();
> +	primary_domain_index =3D find_primary_domain_index();
> =20
> -	if (min_common_depth < 0) {
> +	if (primary_domain_index < 0) {
>  		/*
> -		 * if we fail to parse min_common_depth from device tree
> +		 * if we fail to parse primary_domain_index from device tree
>  		 * mark the numa disabled, boot with numa disabled.
>  		 */
>  		numa_enabled =3D false;
> -		return min_common_depth;
> +		return primary_domain_index;
>  	}
> =20
> -	dbg("NUMA associativity depth for CPU/Memory: %d\n", min_common_depth);
> +	dbg("NUMA associativity depth for CPU/Memory: %d\n", primary_domain_ind=
ex);
> =20
>  	/*
>  	 * Even though we connect cpus to numa domains later in SMP
> @@ -919,14 +919,14 @@ static void __init find_possible_nodes(void)
>  			goto out;
>  	}
> =20
> -	max_nodes =3D of_read_number(&domains[min_common_depth], 1);
> +	max_nodes =3D of_read_number(&domains[primary_domain_index], 1);
>  	for (i =3D 0; i < max_nodes; i++) {
>  		if (!node_possible(i))
>  			node_set(i, node_possible_map);
>  	}
> =20
>  	prop_length /=3D sizeof(int);
> -	if (prop_length > min_common_depth + 2)
> +	if (prop_length > primary_domain_index + 2)
>  		coregroup_enabled =3D 1;
> =20
>  out:
> @@ -1259,7 +1259,7 @@ int cpu_to_coregroup_id(int cpu)
>  		goto out;
> =20
>  	index =3D of_read_number(associativity, 1);
> -	if (index > min_common_depth + 1)
> +	if (index > primary_domain_index + 1)
>  		return of_read_number(&associativity[index - 1], 1);
> =20
>  out:

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--LRFf1+pJXygmf9bq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDT49oACgkQbDjKyiDZ
s5KLRQ//e79QIhgHz3IpR6z23SSCPCAbhtQFkD3QnzXdp82KZuq8kcFbkt1jjlo6
o9+Pmkhzddu8eMxfN6RKeAVcbUfYg6F1zU6tXSFWRsNIG1YOtlio8HaqYi8neVWr
KcO8E6ozxxDB42PcyPLRwBZydJpF0lim/J1afJKj93WJ1tqb9oomuLBiOzNhrqDc
hiwOxLgWSXo4Fy83uiLc2zm3OvKYcJZDd413ChM6Zr+CEK8FYMeybkjh16axPDz/
KjHQyKoH8vw2HDuweE0moo1W4J6BBAWo0xis68goL221hg7xR3N5XOleu3hOWuzC
sQApOy8SW4zJorBWzvzQ8+FJw10N0XaiPX3zsbZl/iHbFAACFH4aktBnDHls584j
/PW/R9grq3MMgxeIoJP21JneJJyT6plMKo/E8iQPH6bK7HJOcT9rMKPPJmN+LoUL
6+UU+JHAKwTV0ypgrH21lxiGffDaDhQsydetCMeK/HIbUmiGG+SAkhLQ8q6gmEGe
ouq8wAzhH19AVFNRnC3eH1YaZ7Q4RAKqevKW10MtLZDw+xm4lCi6s8gw9qFaC9Ew
0GYfg0vzxqS1NPzTB9CeM321+LpGv/kLhKJT/mP6SlC6Fyulf6NT2+1NlAvd5nyf
GEz/tjAZ80aiSOh3XD+n3gJSvJIMZzW305D9volHiMapJqdNng8=
=nesG
-----END PGP SIGNATURE-----

--LRFf1+pJXygmf9bq--
