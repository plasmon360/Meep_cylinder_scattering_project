;This code calculates the extinction, scattering and absorption cross-sections of 2d cylinder.
;Code written by Bala krishna Juluri, http://juluribk.com, Feb 21, 2012


(define-param fcen 0.175) ; pulse center frequency
(define-param df 0.15) ; turn-on bandwidth
(define-param resl 50)
(define-param rad 0.25); unit_cell_size/width_of_metal_slab
(define-param dpml 1) ; thickness of PML layers
(define-param sx (* 12 rad) ) ; the size of the comp cell in X, not including PML
(define sx0 (+ sx (* 2 dpml))) ; cell size in Y direction, including PML
(define sy sx); Aspect ratio of simulation domain
(define sy0 (+ sy (* 2 dpml))) ; cell size in Y direction, including PML
(define-param sample 10)
(define-param nfreq 20)
(define-param structure? false) ; 
(define background(make dielectric (epsilon 1 )))
(define-param scattering? true) ; 
(set! eps-averaging? false)
(set! force-complex-fields? false)
;(set! Courant 0.25)
(set! output-single-precision? true)

(define myAg (make dielectric (epsilon 1.0001)
(polarizations
 (make polarizability
(omega 1e-20) (gamma 0.0038715) (sigma 4.4625e+39))
(make polarizability
(omega 0.065815) (gamma 0.31343) (sigma 7.9247))
(make polarizability
(omega 0.36142) (gamma 0.036456) (sigma 0.50133))
(make polarizability
(omega 0.66017) (gamma 0.0052426) (sigma 0.013329))
(make polarizability
(omega 0.73259) (gamma 0.07388) (sigma 0.82655))
(make polarizability
(omega 1.6365) (gamma 0.19511) (sigma 1.1133))
)))

(define myAg_drude1
(make dielectric (epsilon 8.926)
(polarizations
 (make polarizability
(omega 1e-20) (gamma 0.016373) (sigma 8.7309e+39))
)))


(set! geometry-lattice (make lattice (size sx0 sy0 no-size))) ; Define size of lattice
(set! geometry  (if structure?	
		 (list
	         (make block (center 0 0) (size sx sy infinity)                      (material background))
                 (make cylinder (center 0 0) (radius rad) (height infinity)  (material myAg))
		 )
                  (list      
                 (make block (center 0 0) (size sx sy infinity)                    (material background))
		)
		)) 


(set! symmetries (list (make mirror-sym (direction X) (phase -1)))) ; Our structure and source has mirror symmetry with odd phase. This will reduce the simulation time by half

;PML layers in X and Y-direction
(set! pml-layers (list (make pml (thickness dpml) ))) 


;Source definition
(set! sources (list
               (make source
                 (src (make gaussian-src (frequency fcen) (fwidth df)))
                 (component Ex)
               (center 0 (* rad 4) 0)             (size sx0 0)
	)
	)
)


(set! resolution resl)

; Define a monitor half the size
(define monitor
(volume 
(center 0 0 0)(size sx sy 0)
)
)


(if (not structure?)
(define incident; transmitted flux                                                
      (add-flux fcen df nfreq
                    (make flux-region
                    (center 0 (* rad -4)  0) (size (* rad 4) 0)
		)

	)
)
)

(define left                                       
      (add-flux fcen df nfreq
                    (make flux-region
                    (center (* rad -2)  0 0) (size 0 (* rad 4) )
		)

	)
)

(define right                                                
      (add-flux fcen df nfreq
                    (make flux-region
                    (center  (* rad 2)  0 0) (size 0 (* rad 4) )
		)

	)
)

(define top                                                
      (add-flux fcen df nfreq
                    (make flux-region
                    (center 0 (* rad 2) 0) (size  (* rad 4)  0)
		)

	)
)
(define bottom                                                
      (add-flux fcen df nfreq
                    (make flux-region
                    (center 0 (* rad -2) 0) (size (* rad 4) 0)
		)

	)
)



(if scattering? 
(list 
(if structure? (list (load-minus-flux "left_flux" left) (load-minus-flux "right_flux" right) (load-minus-flux "top_flux" top) (load-minus-flux "bottom_flux" bottom)))
(run-sources+	(stop-when-fields-decayed 1 Ex (vector3 0 (* rad -4) 0) 1e-6))
(if (not structure?) (list (save-flux "left_flux" left) (save-flux "right_flux" right) (save-flux "top_flux" top) (save-flux "bottom_flux" bottom)))     
(if (not structure?) (display-fluxes incident))
(if structure? (display-fluxes left right top bottom))
)

(list 
(run-sources+	(stop-when-fields-decayed 1 Ex (vector3 0 (* rad -4) 0) 1e-6)
;(in-volume monitor(at-beginning output-epsilon))
;(in-volume monitor (to-appended "Ex" (at-every (/ 1 (+ fcen (* 0.5 df)) sample) output-efield-x)))
)
(if structure? (display-fluxes left right top bottom))
)

)
